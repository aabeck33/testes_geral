select actp.idactivity as plano, actp.nmactivity as nmplano, act.idactivity as atividade, act.nmactivity as nmatividade, actp.DTINSERT Dt_cadastro_acao
, (select top 1 wf.idprocess
from gnassocactionplan stpl
inner JOIN GNACTIVITY GNP on stpl.cdassoc = GNP.cdassoc
inner join wfprocess wf on wf.CDGENACTIVITY = gnp.CDGENACTIVITY
where plano.cdgenactivity = stpl.cdactionplan and wf.idprocess like 'ANVTEQ%' order by wf.idprocess) as idprocess
, (select top 1 wf.nmprocess
from gnassocactionplan stpl
inner JOIN GNACTIVITY GNP on stpl.cdassoc = GNP.cdassoc
inner join wfprocess wf on wf.CDGENACTIVITY = gnp.CDGENACTIVITY
where plano.cdgenactivity = stpl.cdactionplan and wf.idprocess like 'ANVTEQ%' order by wf.idprocess) as nmprocess
, coalesce((select substring((select ' | '+ ADATVL2.NMATTRIBUTE as [text()]
from gnassocactionplan stpl
inner JOIN GNACTIVITY GNP on stpl.cdassoc = GNP.cdassoc
inner join wfprocess wf on wf.CDGENACTIVITY = gnp.CDGENACTIVITY
left join WFPROCATTRIB PROCA on PROCA.idprocess = wf.IDOBJECT and proca.cdattribute = 196
LEFT JOIN WFPROATTMULTIVALUE AUAUDATMULT ON (PROCA.CDATTRIBUTE = AUAUDATMULT.CDATTRIBUTE AND AUAUDATMULT.IDPROCATTRIB = PROCA.IDOBJECT )
LEFT JOIN ADATTRIBVALUE ADATVL2 ON (AUAUDATMULT.CDATTRIBUTE = ADATVL2.CDATTRIBUTE AND AUAUDATMULT.CDVALUE = ADATVL2.CDVALUE)
where plano.cdgenactivity = stpl.cdactionplan and wf.idprocess like 'ANVTEQ%' FOR XML PATH('')), 4, 4000)), '') as cliente
, coalesce((select substring((select ' | '+ wf.idprocess as [text()]
from gnassocactionplan stpl
inner JOIN GNACTIVITY GNP on stpl.cdassoc = GNP.cdassoc
inner join wfprocess wf on wf.CDGENACTIVITY = gnp.CDGENACTIVITY
where plano.cdgenactivity = stpl.cdactionplan FOR XML PATH('')), 4, 4000)), '') as listaproc
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
, usr.nmuser as executor, dep.iddepartment, acttype.idgentype, acttype.nmgentype, priori.nmevalresult as Prioridade
, act.dtstartplan, act.dtfinishplan, act.dtstart, act.dtfinish
, act.dsdescription as oque, gntk.dswhy as porque, gntk.dswhere as onde, act.dsactivity as como, aprov.dtapprov
, case
when aprov.fgapprov = 1 then 'Aprovou'
when aprov.fgapprov = 2 then 'Rejeitou'
end as aprovacao
, aprov.dsobs as dsobsaprov
, (select nmuser from aduser where cduser = aprov.cduserapprov) as aprovador
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactivity act on act.cdactivityowner = actp.cdgenactivity
INNER JOIN gntask gntk ON gntk.cdgenactivity = act.cdgenactivity
inner join GNEVALRESULTUSED GNEVALRESACT ON GNEVALRESACT.CDEVALRESULTUSED = actp.CDEVALRSLTPRIORITY
inner join GNEVALRESULT priori on priori.CDEVALRESULT=GNEVALRESACT.CDEVALRESULT
inner join gngentype acttype on acttype.cdgentype = gntk.cdtasktype
LEFT JOIN aduser usr ON act.cduser = usr.cduser
left join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
inner join gnvwapprovresp aprov on aprov.cdapprov = act.cdexecroute and cdprod = 174
and ((aprov.fgpend = 2 and aprov.fgapprov=1) or (aprov.fgpend = 1) or (fgpend is null and fgapprov is null))
inner join (select max(cdcycle) as maxcycle, cdapprov
from gnvwapprovresp where cdprod = 174
group by cdapprov) max_cycle on aprov.cdcycle = max_cycle.maxcycle
where aprov.cdapprov = max_cycle.cdapprov and plano.CDACTIONPLANTYPE = 26
