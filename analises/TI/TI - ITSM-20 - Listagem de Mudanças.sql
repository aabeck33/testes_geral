select distinct *
from (
select wf.idprocess, wf.nmprocess, form.itsm066 as gruposolucionador
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, case when (docs.iddocument is null and wf.fgstatus = 1) then 'Não iniciado'
	   when ((docs.iddocument like 'APL-DE-%' or docs.iddocument like 'SAP-DE-%') and wf.fgstatus = 1) then 'Em andamento'
		when (exists (select 1
                    FROM WFSTRUCT wfs, WFHISTORY HIS
                    WHERE wfs.idstruct = 'Atividade20111012624715' and wfs.idprocess = wf.idobject
                    and HIS.IDSTRUCT = wfs.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and his.nmaction = 'Submeter / Submit') and wf.fgstatus = 1) then 'Entregue'
       when wf.fgstatus = 2 then 'Suspenso'
       when wf.fgstatus = 3 then 'Cancelado'
       when wf.fgstatus = 4 then 'Finalizado'
end Status2
, form.itsm041, form.itsm048, form.itsm040
, docs.VLVALUE as chamado
, (select case when (charindex('#RESP#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#RESP#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#RESP#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#RESP#%'))
) as resp
, (select case when (charindex('#PEND#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#PEND#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#PEND#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#PEND#%'))
) as pend
, (select case when (charindex('#PRIO#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#PRIO#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#PRIO#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#PRIO#%'))
) as prio
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DC-%' or dr.iddocument like 'SAP-DC-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DC-%' or dr.iddocument like 'SAP-DC-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as DC
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DP-%' or dr.iddocument like 'SAP-DP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DP-%' or dr.iddocument like 'SAP-DP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as DP
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DE-%' or dr.iddocument like 'SAP-DE-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-DE-%' or dr.iddocument like 'SAP-DE-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as DE
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-EF-%' or dr.iddocument like 'SAP-EF-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-EF-%' or dr.iddocument like 'SAP-EF-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as EF
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-ET-%' or dr.iddocument like 'SAP-ET-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-ET-%' or dr.iddocument like 'SAP-ET-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as ET
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-QO-%' or dr.iddocument like 'SAP-QO-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-QO-%' or dr.iddocument like 'SAP-QO-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as QO
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-QR-%' or dr.iddocument like 'SAP-QR-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-QR-%' or dr.iddocument like 'SAP-QR-%')  and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as QR
, (select top 1 dr.iddocument from dcdocrevision dr inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) +
' / '+ (select top 1 case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc from dcdocrevision dr inner join dcdocument doc on doc.cddocument = dr.cddocument inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235 where (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%') and atr.vlvalue = docs.vlvalue order by dr.cdrevision desc) as RP
, case when (<!%IDLOGIN%> = adrusr.idlogin) then 1 else 2 end meusgs
, case when (<!%IDLOGIN%> = adrcoord.coord) then 1 else 2 end eucoord, adrcoord.coord
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, wfs.idstruct, wfs.nmstruct, wf.dtfinish
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
            inner join dcdocumentattrib att on att.cdrevision = rev.cdrevision and att.cdattribute = 235 and att.cdrevision = rev.cdrevision
            where (rev.iddocument like 'APL-__-%' or rev.iddocument like 'SAP-__-%')
) docs on docs.idprocess = wf.idobject
left join (select usr1.idlogin, adr.cdrole, adr.idrole from aduser usr1
           inner join aduserrole adru on adru.cduser = usr1.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           where adr.cdroleowner = 1404 and usr1.idlogin = <!%IDLOGIN%>) adrusr on  (adrusr.cdrole = wfa.cdrole or (wfa.cdrole is null and adrusr.idrole = form.itsm035))
left join (select usr1.idlogin, adr.cdrole, adr.idrole, coord.ITSM002 as coord from aduser usr1
           inner join aduserrole adru on adru.cduser = usr1.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           inner join DYNitsm017 lgs on lgs.itsm001 = case when charindex('_', adr.idrole) < 1 then 'null' else left(adr.idrole, charindex('_', adr.idrole)-1) end
           inner join DYNitsm016 coord on lgs.OIDABCBSAGZNWY2N0Q = coord.oid
           where adr.cdroleowner = 1404 and coord.ITSM002 = <!%IDLOGIN%>) adrcoord on (adrcoord.cdrole = wfa.cdrole or (wfa.cdrole is null and adrcoord.idrole = form.itsm035))
where wf.cdprocessmodel = 5679 and form.itsm035 is not null and (wf.dtfinish is null or datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()))  -- and wf.fgstatus <> 4
) sub
where status2 is not null
