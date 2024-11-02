select P.NMIDTASK AS "Id. do programa", P.NMTASK AS "Nome do programa"
, case p.FGPHASE
    when 1 then 'Planejamento'
    when 2 then 'Execução'
    when 3 then 'Verificação'
    when 4 then 'Encerrado'
    when 5 then 'Aprovação'
    when 6 then 'Suspenso'
    when 7 then 'Cancelado'
end fase
, usr.nmuser as resp
, p.DTPLANST as "Início planejado", p.DTPLANEND as "Fim planejado"
, p.DTREPLST as "Início replan.", p.DTREPLEND	as "Fim replan."
, p.DTACTST as "Início real", p.DTACTEND as "Fim real"
, case when (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                  when proj.DTPLANST = proj.DTPLANEND then 0
                                  else case when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                            when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                            else coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0)
                                       end
                             end) as decimal(7,2)) as porPlan
             from prtask proj
             where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                   select NMIDTASK
                   from prtask proj1
                   where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask)) is not null
       then
             (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                   when proj.DTPLANST = proj.DTPLANEND then 0
                                   else case when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                             when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                             else coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0)
                                        end
                              end) as decimal(7,2)) as porPlan
              from prtask proj
              where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                    select NMIDTASK
                    from prtask proj1
                    where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask))
       else
             (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                   when proj.DTPLANST = proj.DTPLANEND then 0
                                   else case when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                             when coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                             else coalesce(cast(datediff(dd, proj.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTPLANST, proj.DTPLANEND) as decimal(7,2)) * 100, 0)
                                        end
                              end) as decimal(7,2)) as porPlan
              from prtask proj
              where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                    select NMIDTASK
                    from prtask proj1
                    where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask in (
                          select cdtask
                          from prtask proj2
                          where proj2.NRTASKINDEX = 0 and proj2.cdtask = proj2.cdbasetask and proj2.cdtasktype = 25 and proj2.fgtasktype = 5 and proj2.nmidtask in (
                                select nmidtask
                                from prtask proj3
                                where proj3.cdtask <> proj3.cdbasetask and proj3.cdtasktype = 25 and proj3.fgtasktype = 5 and proj3.cdbasetask = p.cdtask))))
  end as porPlanPrj
, case when (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                  when proj.DTREPLST = proj.DTREPLEND then 0
                                  else case when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                            when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                            else coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0)
                                       end
                             end) as decimal(7,2)) as porReplan
             from prtask proj
             where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                   select NMIDTASK
                   from prtask proj1
                   where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask)) is not null
      then
            (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                  when proj.DTREPLST = proj.DTREPLEND then 0
                                  else case when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                            when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                            else coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0)
                                       end
                             end) as decimal(7,2)) as porReplan
             from prtask proj
             where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                   select NMIDTASK
                   from prtask proj1
                   where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask))
      else
            (select cast(avg(case when proj.QTACTPERC = 100 then 100
                                  when proj.DTREPLST = proj.DTREPLEND then 0
                                  else case when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                                            when coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                                            else coalesce(cast(datediff(dd, proj.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, proj.DTREPLST, proj.DTREPLEND) as decimal(7,2)) * 100, 0)
                                       end
                             end) as decimal(7,2)) as porReplan
             from prtask proj
             where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                   select NMIDTASK
                    from prtask proj1
                    where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask in (
                          select cdtask
                          from prtask proj2
                          where proj2.NRTASKINDEX = 0 and proj2.cdtask = proj2.cdbasetask and proj2.cdtasktype = 25 and proj2.fgtasktype = 5 and proj2.nmidtask in (
                                select nmidtask
                                from prtask proj3
                                where proj3.cdtask <> proj3.cdbasetask and proj3.cdtasktype = 25 and proj3.fgtasktype = 5 and proj3.cdbasetask = p.cdtask))))
  end as porReplanPrj
, 
--coalesce(p.QTACTPERC, 0) 
case when (select cast(avg(coalesce(proj.QTACTPERC, 0)) as decimal(7,2)) as porReal
             from prtask proj
             where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                   select NMIDTASK
                   from prtask proj1
                   where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask)) is not null
       then
             (select cast(avg(coalesce(proj.QTACTPERC, 0)) as decimal(7,2)) as porReal
              from prtask proj
              where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                    select NMIDTASK
                    from prtask proj1
                    where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask = p.cdtask))
       else
             (select cast(avg(coalesce(proj.QTACTPERC, 0)) as decimal(7,2)) as porReal
              from prtask proj
              where proj.fgtasktype = 1 and proj.cdtasktype = 4 and proj.FGPHASE < 6 and proj.nmidtask in (
                    select NMIDTASK
                    from prtask proj1
                    where proj1.cdtask <> proj1.cdbasetask and proj1.cdtasktype = 4 and proj1.fgtasktype = 5 and proj1.cdbasetask in (
                          select cdtask
                          from prtask proj2
                          where proj2.NRTASKINDEX = 0 and proj2.cdtask = proj2.cdbasetask and proj2.cdtasktype = 25 and proj2.fgtasktype = 5 and proj2.nmidtask in (
                                select nmidtask
                                from prtask proj3
                                where proj3.cdtask <> proj3.cdbasetask and proj3.cdtasktype = 25 and proj3.fgtasktype = 5 and proj3.cdbasetask = p.cdtask))))
  end as porRealPrj
, 1 as qtd
from PRTASK P
inner join aduser usr on usr.cduser = p.CDTASKRESP
inner join prpriority prio on prio.cdpriority = p.cdpriority
inner join prtasktype pty on pty.cdtasktype = p.cdtasktype
where p.cdtasktype = 25 and P.FGTASKTYPE = 5 and p.cdtask = p.cdbasetask
and P.NMIDTASK like 'PTI-%'
