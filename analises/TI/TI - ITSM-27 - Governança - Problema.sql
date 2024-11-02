select wf.idprocess, wf.nmprocess, wf.dtstart+coalesce(wf.tmstart,cast(0 as datetime)) as inic, wf.dtfinish+coalesce(wf.tmfinish,cast(0 as datetime)) as fim, gnrev.NMREVISIONSTATUS as situac
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, case when (coalesce(assoc.itsm035, form.itsm035) = '' or coalesce(assoc.itsm035, form.itsm035) is null) then 'N/A' else substring(coalesce(assoc.itsm035, form.itsm035), 1, coalesce(charindex('_', coalesce(assoc.itsm035, form.itsm035))-1, len(coalesce(assoc.itsm035, form.itsm035)))) end as gsb
, coalesce(assoc.itsm002, form.itsm002) as objeto, coalesce(assoc.itsm003, form.itsm003) as servico, coalesce(assoc.itsm004, form.itsm004) as complem , coalesce(assoc.ITSM034, form.ITSM034) as descr
, assoc.pai as refer
, form.itsm036 as unidserv
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join (
            SELECT wff.idprocess as pai, p.idprocess, formf.*
            FROM gnassocworkflow bidirect 
            INNER JOIN gnassoc gnas ON bidirect.cdassoc = gnas.cdassoc AND gnas.nrobjectparent = 99207887
            LEFT OUTER JOIN gnactivity gnac ON gnas.cdassoc = gnac.cdassoc
            INNER JOIN wfprocess p ON p.cdgenactivity = gnac.cdgenactivity
            INNER JOIN inoccurrence incid ON p.idobject = incid.idworkflow
            INNER JOIN gngentype gnt ON incid.cdoccurrencetype = gnt.cdgentype
            LEFT OUTER JOIN gnrevisionstatus gnrs ON incid.cdstatus = gnrs.cdrevisionstatus
            left join wfprocess wff on wff.idobject = bidirect.idprocess and wff.cdprocessmodel in (5251,5692,5679,5716)
            inner join gnassocformreg gnff on (wff.cdassocreg = gnff.cdassoc)
            inner join DYNitsm formf on (gnff.oidentityreg = formf.oid)
            WHERE p.idobject IS NOT NULL AND p.cdprodautomation = 202 AND p.cdprodautomation IS NOT NULL
            and p.cdprocessmodel in (5251,5470,5692,5679,5716)
            and bidirect.cdassocworkflow = (select min(bidi.cdassocworkflow) from gnassocworkflow bidi where bidi.cdassoc = bidirect.cdassoc)
) assoc on assoc.idprocess = wf.idprocess
where wf.cdprocessmodel = 5470
