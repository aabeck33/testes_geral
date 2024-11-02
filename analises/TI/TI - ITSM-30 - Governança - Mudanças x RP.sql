select wf.idprocess, wf.nmprocess
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, docs.VLVALUE as chamado
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 and atr.cdrevision = dr.cdrevision 
  where (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as RPattr
, (select top 1 dr.iddocument
FROM dcdocrevision dr 
INNER JOIN dcdocument dc ON dc.cddocument = dr.cddocument 
INNER JOIN gnrevision gr ON gr.cdrevision = dr.cdrevision 
INNER JOIN wfprocdocument wfdoc ON dr.cddocument = wfdoc.cddocument AND (dr.cdrevision = wfdoc.cddocumentrevis OR (wfdoc.cddocumentrevis IS NULL AND dr.fgcurrent = 1))
INNER JOIN wfstruct wfs ON wfdoc.idstruct = wfs.idobject 
where wfs.idprocess = wf.idobject and (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%')
order by dr.cdrevision desc
) as RPassoc
, wfs.idstruct, wfs.nmstruct, wf.dtfinish, wf.dtstart
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 2
left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
left join (
            select wfs.idprocess, rev.iddocument, att.VLVALUE, rev.cddocument, rev.cdrevision
            from wfstruct wfs
            inner join wfprocdocument wfdoc on wfdoc.idstruct = wfs.idobject
            inner join dcdocrevision rev on rev.cddocument = wfdoc.cddocument and (rev.cdrevision = wfdoc.cddocumentrevis or (wfdoc.cddocumentrevis is null and rev.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)))
            inner join dcdocumentattrib att on att.cdrevision = rev.cdrevision and att.cdattribute = 235
            where (rev.iddocument like 'APL-__-%' or rev.iddocument like 'SAP-__-%')
) docs on docs.idprocess = wf.idobject
where wf.cdprocessmodel = 5679
