select actp.idactivity as plano, actp.nmactivity as nmplano, act.idactivity as atividade, act.nmactivity as nmatividade, actp.DTINSERT Dt_cadastro_acao
, coalesce((select substring((select ' | '+ wf.idprocess as [text()]
            from gnassocactionplan stpl
            inner JOIN GNACTIVITY GNP on stpl.cdassoc = GNP.cdassoc
            inner join wfprocess wf on wf.CDGENACTIVITY = gnp.CDGENACTIVITY
            where plano.cdgenactivity = stpl.cdactionplan FOR XML PATH('')), 4, 4000)), 'NA') as idprocess 
, case act.fgstatus
    when 1 then 'Planejamento'
    when 2 then 'Aprovação do planejamento'
    when 3 then 'Execução'
    when 4 then 'Verificação da eficácia / Aprovação da execução'
    when 5 then 'Encerrada'
    WHEN 6 THEN 'Cancelado' 
    WHEN 7 THEN 'Cancelado' 
    WHEN 8 THEN 'Cancelado' 
    WHEN 9 THEN 'Cancelado' 
    WHEN 10 THEN 'Cancelado' 
    WHEN 11 THEN 'Cancelado'
end as status
, usr.nmuser as executor, dep.iddepartment +' - '+ dep.nmdepartment as executorarea, act.dtstartplan, act.dtfinishplan, act.dtstart, act.dtfinish
, act.dsdescription as oque, gntk.dswhy as porque, gntk.dswhere as onde, act.dsactivity as como, aprov.dtapprov
, case
    when aprov.fgapprov = 1 then 'Aprovou'
    when aprov.fgapprov = 2 then 'Rejeitou'
end as aprovacao
, case
when suce.fgstatus <= 4 then 'Não'
when suce.fgstatus > 4 then 'Sim'
else ''
end liberada
, aprov.dsobs as dsobsaprov
, (select nmuser from aduser where cduser = aprov.cduserapprov) as aprovador
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactivity act on act.cdactivityowner = actp.cdgenactivity
INNER JOIN gntask gntk ON gntk.cdgenactivity = act.cdgenactivity
left outer join GNACTIVITYLINKS link on link.cdactivity = act.cdgenactivity
left outer join gnactivity suce on suce.cdgenactivity = link.CDPREDECESSOR
LEFT OUTER JOIN aduser usr ON act.cduser = usr.cduser
LEFT OUTER JOIN aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1
LEFT OUTER JOIN addepartment dep on dep.cddepartment = rel.cddepartment
inner join gnvwapprovresp aprov on aprov.cdapprov = act.cdexecroute and cdprod=174
      and ((aprov.fgpend = 2 and aprov.fgapprov=1) or (aprov.fgpend = 1) or (fgpend is null and fgapprov is null))
inner join (select max(cdcycle) as maxcycle, cdapprov
      from gnvwapprovresp where cdprod=174
      group by cdapprov) max_cycle on  aprov.cdcycle = max_cycle.maxcycle
where aprov.cdapprov = max_cycle.cdapprov and plano.CDACTIONPLANTYPE in (215, 216, 217, 218, 219, 220)
