select wf.idprocess, wf.nmprocess, wf.dtstart+coalesce(wf.tmstart,cast(0 as datetime)) as inic, wf.dtfinish+coalesce(wf.tmfinish,cast(0 as datetime)) as fim, gnrev.NMREVISIONSTATUS as situac
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, form.de008 as investigador, form.de007 as acoesim, form.de006 as descr
, 1 as quant
from DYNdesvti form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where wf.cdprocessmodel = 5756
