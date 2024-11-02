select wf.idprocess, wfa.nmuser, adr.idrole, wf.nmuserstart, wf.dtstart+wf.tmstart as inicio, wf.dtfinish+wf.tmfinish as fim
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
, case wfs.fgstatus when 1 then 'Não entrou ainda' when 2 then 'Em execução' when 3 then 'Executada' else 'N/A' end as atvstatus
from DYNsolws form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFSTRUCT wfs on wf.idobject = wfs.idprocess and wfs.idstruct = 'Atividade1981103642935'
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
left join adrole adr on adr.cdrole = wfa.cdrole
where wf.cdprocessmodel = 5283
