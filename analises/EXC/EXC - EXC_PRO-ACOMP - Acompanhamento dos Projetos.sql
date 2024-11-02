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
       else cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100
  end as "% planejado do projeto"
, case when p.QTACTPERC = 100 then 1
       when p.DTPLANST = p.DTPLANEND then 0
       else coalesce(p.QTACTPERC, 0) / (cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100)
  end as "IDP"
, prio.idPRIORITY
, case when p.DTPLANST = p.DTPLANEND then 'N/A'
       when ((cast(datediff(dd, p.DTPLANST, getdate()) as decimal(7,2)) / cast(datediff(DD, p.DTPLANST, p.DTPLANEND) as decimal(7,2)) * 100) - p.QTACTPERC <= 0) then 'No prazo'
       else 'Atrasado'
  end statusprj
, substring(pty.idtasktype, 5, 45) as unidade
, (select vlvalue from prtaskattrib where cdattribute = 529 and cdtask = p.cdtask) as "CAPEX Aprovado"
, (select vlvalue from prtaskattrib where cdattribute = 530 and cdtask = p.cdtask) as "CAPEX Planejado"
, (select vlvalue from prtaskattrib where cdattribute = 531 and cdtask = p.cdtask) as "CAPEX Realizado"
, case when (select vlvalue from prtaskattrib where cdattribute = 529 and cdtask = p.cdtask) is null or
            (select vlvalue from prtaskattrib where cdattribute = 529 and cdtask = p.cdtask) = 0 then 0
       else (select vlvalue from prtaskattrib where cdattribute = 531 and cdtask = p.cdtask) / (select vlvalue from prtaskattrib where cdattribute = 529 and cdtask = p.cdtask)
  end "IDC"
, 1 as qtd
from PRTASK P
inner join aduser usr on usr.cduser = p.CDTASKRESP
inner join prpriority prio on prio.cdpriority = p.cdpriority
inner join prtasktype pty on pty.cdtasktype = p.cdtasktype
where P.FGTASKTYPE = 1 and P.NRTASKINDEX = 0
and p.cdtasktype in (select cdtasktype from prtasktype where CDTASKTYPEOWNER = 15)
