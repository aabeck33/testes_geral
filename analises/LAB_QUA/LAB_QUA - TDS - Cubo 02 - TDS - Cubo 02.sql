Select wf.idprocess, wf.nmprocess
, plano.idactivity as idplano, atv.idactivity as idatividade, atv.nmactivity as nmatividade
, (select nmuser from aduser where cduser=atv.cduser) as executor
, case atv.fgstatus
     when  1 then 'Em planejamento'
     when  2 then 'Em aprovavação do planejamento'
     when  3 then 'Em execução'
     when  4 then 'Em aprovação da execução'
     when  5 then 'Encerrada'
     when  7 then 'Cancelada'
     when  9 then 'Cancelada'
     when 10 then 'Cancelada'
     when 11 then 'Cancelada'
end as Status
, format(atv.dtfinishplan,'dd/MM/yyyy') as dtexcecucaoplan, datepart(yyyy,atv.dtfinishplan) as dtexcecucaoplan_ano, datepart(MM,atv.dtfinishplan) as dtexcecucaoplan_mes
, format(atv.dtfinish,'dd/MM/yyyy') as dtexcecucao, datepart(yyyy,atv.dtfinish) as dtexcecucao_ano, datepart(MM,atv.dtfinish) as dtexcecucao_mes
, 1 as quantidade
from WFPROCESS wf
left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
left JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
left JOIN gnactivity atv ON atv.cdactivityowner = plano.cdgenactivity
where wf.cdprocessmodel in (1,17,28) and atv.cduser in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
union
Select null as idprocess, null as nmprocess
, plano.idactivity as idplano, atv.idactivity as idatividade, atv.nmactivity as nmatividade
, (select nmuser from aduser where cduser=atv.cduser) as executor
, case atv.fgstatus
     when  1 then 'Em planejamento'
     when  2 then 'Em aprovavação do planejamento'
     when  3 then 'Em execução'
     when  4 then 'Em aprovação da execução'
     when  5 then 'Encerrada'
     when  7 then 'Cancelada'
     when  9 then 'Cancelada'
     when 10 then 'Cancelada'
     when 11 then 'Cancelada'
end as Status
, format(atv.dtfinishplan,'dd/MM/yyyy') as dtexcecucaoplan, datepart(yyyy,atv.dtfinishplan) as dtexcecucaoplan_ano, datepart(MM,atv.dtfinishplan) as dtexcecucaoplan_mes
, format(atv.dtfinish,'dd/MM/yyyy') as dtexcecucao, datepart(yyyy,atv.dtfinish) as dtexcecucao_ano, datepart(MM,atv.dtfinish) as dtexcecucao_mes
, 1 as quantidade
from gnactionplan gnpl
left JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
left JOIN gnactivity atv ON atv.cdactivityowner = plano.cdgenactivity
where GNPL.CDACTIONPLANTYPE in (23, 26, 27) and atv.cduser in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
