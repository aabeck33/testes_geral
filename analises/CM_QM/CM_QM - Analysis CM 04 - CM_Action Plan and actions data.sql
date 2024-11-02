Select wf.idprocess, wf.nmprocess, wf.dtstart as dtabertura
, CASE wf.fgstatus when 3 then (select top 1 his1.dthistory + his1.tmhistory
                                from wfhistory his1
                                inner join wfprocess wf1 on his1.idprocess = wf1.idobject and wf1.idprocess = wf.idprocess
                                where HIS1.FGTYPE = 3
                                order by his1.dthistory + his1.tmhistory desc
) else wf.dtfinish end as dtfechamento
, CASE wf.fgstatus WHEN 1 THEN 'In progress' WHEN 2 THEN 'Suspended' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'Finished' WHEN 5 THEN 'Blocked for edition' END AS statusproc
, plano.idactivity as Plano_id, plano.nmactivity as Plano_nm
, case plano.fgstatus
     when  1 then 'Planning'
     when  2 then 'Planning approval'
     when  3 then 'In progress'
     when  4 then 'Execution approval'
     when  5 then 'Finished'
     when  6 then 'Canceled'
     when  7 then 'Canceled'
     when  9 then 'Canceled'
     when 10 then 'Canceled'
     when 11 then 'Canceled'
end as Plano_st
, case plano.fgstatus
     when  5 then plano.dtfinish
     when  6 then plano.dtupdate
     when  7 then plano.dtupdate
     when  9 then plano.dtupdate
     when 10 then plano.dtupdate
     when 11 then plano.dtupdate
end as Plano_fimr
, (select nmuser from aduser where cduser = acao.cduser) as Acao_exec
, (select dep.nmdepartment from aduser usr inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1 inner join addepartment dep on dep.cddepartment = rel.cddepartment where usr.cduser = acao.cduser) as Acao_area
, acao.idactivity as idAcao, acao.nmactivity as Acao_nm
, acao.dtstartplan as Acao_inicp, acao.dtfinishplan as Acao_fimp, acao.dtstart as Acao_inicr
, case when (datediff(DD, acao.dtfinishplan, case when acao.dtfinish is not null then acao.dtfinish else getdate() end) <= 0) then 'On Time' else 'Delayed' end as Acao_leadtimeStatus
, case acao.fgstatus
     when  5 then acao.dtfinish
     when  6 then acao.dtupdate
     when  7 then acao.dtupdate
     when  9 then acao.dtupdate
     when 10 then acao.dtupdate
     when 11 then acao.dtupdate
end as Acao_fimr
, case acao.fgstatus
     when  1 then 'Planning'
     when  2 then 'Planning approval'
     when  3 then 'In progess'
     when  4 then 'Execution approval'
     when  5 then 'Finished'
     when  6 then 'Canceled'
     when  7 then 'Canceled'
     when  9 then 'Canceled'
     when 10 then 'Canceled'
     when 11 then 'Canceled'
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
    else 'Not'
end as acao_disp
, case when aprov.fgapprov = 1 then 'Yes' when aprov.fgapprov = 2 then 'Not' end as Apr_acao
, case when (coalesce(aprov.nmuserapprov, nmuser)) is not null then (coalesce(aprov.nmuserapprov, nmuser)) end as Apr_exec
, aprov.dtapprov as Apr_dt, aprov.cdcycle as qtdCiclos
, case when (acao.dtfinish is null and aprov.dtapprov is null) then null when (acao.dtfinish is null) then datediff(DD, acao.dtfinish, getdate()) else datediff(DD, acao.dtfinish, aprov.dtapprov) end as Apr_LeadTime
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
where cdprocessmodel=4468
