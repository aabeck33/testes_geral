Select wf.idprocess, wf.nmprocess, wf.dtstart as dtabertura, wf.dtfinish as dtfechamento
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS statusproc
, plano.idactivity as Plano_id, plano.nmactivity as Plano_nm
, case plano.fgstatus
     when  1 then 'Em planejamento'
     when  2 then 'Em aprovavação do planejamento'
     when  3 then 'Em execução'
     when  4 then 'Em aprovação da execução'
     when  5 then 'Encerrado'
     when  6 then 'Cancelado'
     when  7 then 'Cancelado'
     when  9 then 'Cancelado'
     when 10 then 'Cancelado'
     when 11 then 'Cancelado'
end as Plano_st
, (select nmuser from aduser where cduser = acao.cduser) as Acao_exec
, (select dep.nmdepartment from aduser usr inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1 inner join addepartment dep on dep.cddepartment = rel.cddepartment where usr.cduser = acao.cduser) as Acao_area
, acao.idactivity as idAcao, acao.nmactivity as Acao_nm
, acao.dtstartplan as Acao_inicp, acao.dtfinishplan as Acao_fimpo, acao.dtstart as Acao_inicr, acao.dtfinish as Acao_fimr
, case acao.fgstatus
     when  1 then 'Em planejamento'
     when  2 then 'Em aprovavação do planejamento'
     when  3 then 'Em execução'
     when  4 then 'Em aprovação da execução'
     when  5 then 'Encerrada'
     when  6 then 'Cancelada'
     when  7 then 'Cancelada'
     when  9 then 'Cancelada'
     when 10 then 'Cancelada'
     when 11 then 'Cancelada'
end as Acao_st
, (cast(substring((select ', '+ gnact.idactivity as [text()]
from GNACTIVITYLINKS pred
inner join gnactivity gnact on pred.cdpredecessor = gnact.cdgenactivity
where pred.cdactivity = acao.cdgenactivity
FOR XML PATH('')), 3, 250) as varchar(255))) as acao_predecessora
, case
    when (plano.fgstatus = 3 and acao.fgstatus = 3 and (select count(pred2.cdactivity) from GNACTIVITYLINKS pred2 where pred2.cdactivity = acao.cdgenactivity) = 0)
         or (plano.fgstatus = 3 and acao.fgstatus = 3 and (select min(gnact.fgstatus) from GNACTIVITYLINKS pred 
             inner join gnactivity gnact on pred.cdpredecessor = gnact.cdgenactivity where pred.cdactivity = acao.cdgenactivity)  > 4) then 'Sim'
    else 'Não'
end as acao_disp
, cast(acao.dsdescription as varchar(4000)) as como
, case when aprov.fgapprov = 1 then 'Sim' when aprov.fgapprov = 2 then 'Não' end as Apr_acao
, case when (coalesce(aprov.nmuserapprov, nmuser)) is not null then (coalesce(aprov.nmuserapprov, nmuser)) end as Apr_exec
, aprov.dtapprov as Apr_dt, aprov.cdcycle as qtdCiclos
, 1 as quantidade
from WFPROCESS wf
inner JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
inner join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
inner JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
inner JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
inner join gnactivity acao on plano.cdgenactivity = acao.cdactivityowner
left join gnvwapprovresp aprov on aprov.cdapprov = acao.cdexecroute and cdprod=174
      and ((aprov.fgpend = 2 or (fgpend is null and fgapprov is null))
      or (fgpend = 1 and fgapprov is null)) and aprov.cdcycle = (select max(cdcycle) from gnvwapprovresp aprov2 where aprov2.cdprod = aprov.cdprod and aprov2.cdapprov = aprov.cdapprov)
where cdprocessmodel=53
