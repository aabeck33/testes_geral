select P.NMIDTASK AS "Id. do projeto",P.NMTASK AS "Nome do projeto"
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
, coalesce(p.QTACTPERC, 0) as "% realizado do projeto"
, case when p.QTACTPERC = 100 then 100
       when p.DTPLANST = p.DTPLANEND then 0
       else case when coalesce(cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                 when coalesce(cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                 else coalesce(cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100, 0) 
            end
  end as "% planejado do projeto"
, case when p.QTACTPERC = 100 then 100
       when p.DTREPLST = p.DTREPLEND then 0
       else case when coalesce(cast(datediff(dd, p.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTREPLST, p.DTREPLEND) as decimal(7,2)) * 100, 0) >= 100 then 100
                 when coalesce(cast(datediff(dd, p.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTREPLST, p.DTREPLEND) as decimal(7,2)) * 100, 0) <= 0 then 0
                 else coalesce(cast(datediff(dd, p.DTREPLST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTREPLST, p.DTREPLEND) as decimal(7,2)) * 100, 0)
            end
  end as "% replanejado do projeto"
, case when p.QTACTPERC = 100 then 1
       when p.DTPLANST = p.DTPLANEND then 0
       else case when coalesce(p.QTACTPERC, 0) / (cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100) >= 100 then 100
                 when coalesce(p.QTACTPERC, 0) / (cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100) <= 0 then 0
                 else coalesce(p.QTACTPERC, 0) / (cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100)
            end
  end as IDP
, prio.idPRIORITY as Prioridade
, 1 as qtd
, progr.nmidtask as programa
from PRTASK P
inner join aduser usr on usr.cduser = p.CDTASKRESP
inner join prpriority prio on prio.cdpriority = p.cdpriority
inner join prtasktype pty on pty.cdtasktype = p.cdtasktype
inner join prtask prog on prog.nmidtask = p.nmidtask and prog.fgtasktype = 5 and prog.cdtasktype = 4
inner join prtask progr on progr.cdtask = prog.CDBASETASK
where p.cdtasktype = 4 and P.FGTASKTYPE = 1 and P.NRTASKINDEX = 0 and prog.cdtask <> prog.cdbasetask
and (progr.NMIDTASK like '%'+ right(cast(datepart(yy, getdate()) as varchar), 2) +'%' or
	 progr.NMIDTASK like '%'+ right(cast(datepart(yy, dateadd(year,-1,getdate())) as varchar), 2) +'%')
