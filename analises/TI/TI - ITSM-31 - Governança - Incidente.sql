select wf.idprocess, wf.nmprocess, wf.dtstart+coalesce(wf.tmstart,cast(0 as datetime)) as inic, wf.dtfinish+coalesce(wf.tmfinish,cast(0 as datetime)) as fim, gnrev.NMREVISIONSTATUS as situac
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as gsb
, form.itsm002 as objeto, form.itsm003 as servico, form.itsm004 as complem, form.ITSM034 as descr
, restx.NMEVALRESULT as prioridade
, form.itsm048 as paraQuemPediuUnid, coalesce((select nmdepartment from addepartment where iddepartment = form.itsm040), form.itsm040) as paraQuemPediuDep
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join GNEVALRESULTUSED res on res.CDEVALRESULTUSED = wf.CDEVALRSLTPRIORITY
left join GNEVALRESULT restx on restx.CDEVALRESULT = res.CDEVALRESULT
where wf.cdprocessmodel = 5251 and coalesce(form.itsm058, form.itsm044) = 2
