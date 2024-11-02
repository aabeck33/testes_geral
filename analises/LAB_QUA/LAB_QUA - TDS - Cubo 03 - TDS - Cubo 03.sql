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
, case form.tbs011 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tbs035 when 1 then 'Crítico' when 2 then 'Não crítico' end as critfin
, case form.tbs029 when 1 then 'Sim' when 2 then 'Não' end as confirmada
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, laboc.tbs001 as laboratorio
, 1 as quantidade
from DYNtbs016 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus GNrev on (wf.cdstatus = GNrev.cdrevisionstatus)
left join aduser usr on usr.cduser = wf.cdUSERSTART
left join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs026 laboc on laboc.oid = form.OIDABCYa3ABCdTh
--
left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
left JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
left JOIN gnactivity atv ON atv.cdactivityowner = plano.cdgenactivity
where wf.cdprocessmodel in (38) and atv.cduser in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
union
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
, case form.tds008 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tds031 when 1 then 'Crítico' when 2 then 'Não crítico' end as critfin
, case form.tds025 when 1 then 'Sim' when 2 then 'Não' end as confirmada
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, laboc.tbs001 as laboratorio
, 1 as quantidade
from DYNtds016 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus GNrev on (wf.cdstatus = GNrev.cdrevisionstatus)
left join aduser usr on usr.cduser = wf.cdUSERSTART
left join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs026 laboc on laboc.oid = form.OIDABCIsOABCqaE
--
left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
left JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
left JOIN gnactivity atv ON atv.cdactivityowner = plano.cdgenactivity
where wf.cdprocessmodel in (38) and atv.cduser in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
