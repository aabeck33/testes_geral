Select wf.idprocess, wf.nmprocess, gnact.dtfinishplan, wf.dtstart as dtabertura
, GNrev.NMREVISIONSTATUS as status
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, wf.dtfinish as dtfechamento
, case form.tds016  when 1 then 'CM Crítico' when 2 then 'CM Não crítico' end as Criticidade
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
left JOIN gnactivity gnact ON gnact.cdgenactivity = (
select top 1 gnactp.cdgenactivity from gnactivity gnact1
inner join gnassocactionplan stpl on stpl.cdassoc = gnact1.cdassoc
inner JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
inner JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
where gnact1.idactivity like '%-CM' and gnact1.CDGENACTIVITY = wf.CDGENACTIVITY
order by gnactp.dtfinishplan desc
)
where cdprocessmodel=5842
