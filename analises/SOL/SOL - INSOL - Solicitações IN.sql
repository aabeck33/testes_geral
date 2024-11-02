Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura, wf.dtfinish
, case form.tds003
when 1 then 'Desvio'
when 2 then 'Controle de Mudança'
when 3 then 'Reclamação de Mercado'
when 4 then 'Evento da Qualidade'
when 5 then 'Investigação laboratorial'
else 'N;A'
end tipo
, CASE wf.fgstatus
WHEN 1 THEN 'Em andamento'
WHEN 2 THEN 'Suspenso'
WHEN 3 THEN 'Cancelado'
WHEN 4 THEN 'Encerrado'
WHEN 5 THEN 'Bloqueado para edição'
END AS statusproc
, case form.tds005 when 1 then 'Alteração de prazo de atividade do processo' when 2 then 'Alteração de prazo de atividade de Plano de Ação'
when 3 then 'Cancelamento de atividade de Plano de Ação' when 4 then 'Adendo' when 5 then 'Cancelamento do Processo' end tpsolicitação
, coalesce((select substring((select ' | '+ tds013 +' - '+ tds014 as [text()] from DYNtds041 where OIDABCFHvABCauy = form.oid FOR XML PATH('')), 4, 40000)), 'NA') as listaplano --listaplanoac--
, coalesce((select substring((select ' | '+ tds001 as [text()] from DYNtds042 where OIDABCyheABCdqV = form.oid FOR XML PATH('')), 4, 40000)), 'NA') as listaproc --listaproc--
, 1 as quantidade
from DYNtds038 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.CDUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs001 unid on unid.oid = form.OIDABC5qIABClq3
left join DYNtbs011 areasol on areasol.oid = form.OIDABChRhABCLwI
where wf.cdprocessmodel = 3239
