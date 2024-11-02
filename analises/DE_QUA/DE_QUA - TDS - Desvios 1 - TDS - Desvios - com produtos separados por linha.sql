select * from (Select  wf.idprocess,  wf.DTSTART AS DATA_ABERTURA, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, GETDATE() as dtaprovfinal
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, 'NA' as repqualidade, dispfin.tbs009 as disposfinal
, prod.tbs003 as codprod, prod.tbs002 as descprod, prod.tbs004 as lotes
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity + ' - ' + CASE
                     WHEN gnactp.NRTASKSEQ = 1 THEN 'Alta prioridade'
                     WHEN gnactp.NRTASKSEQ = 2 THEN 'Média prioridade'
                     WHEN gnactp.NRTASKSEQ = 3 THEN 'Baixa prioridade'
                     ELSE ''
                 END as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, 1 as quantidade
from DYNtbs010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs012 prod on form.oid = prod.OIDABCBZmABCZOW
left join DYNtbs009 dispfin on dispfin.oid = form.OIDABCInNABCCBb
where wf.cdprocessmodel=17
union
Select wf.idprocess, wf.DTSTART AS DATA_ABERTURA, gnrev.NMREVISIONSTATUS as status, wf.nmprocess

,(SELECT str.DTEXECUTION FROM WFSTRUCT STR WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) as dtaprovfinal

, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, form.tds071 as repqualidade

, dispfin.tbs009 as disposfinal
, prod.tbs003 as codprod, prod.tbs002 as descprod, prod.tbs004 as lotes
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity + ' - ' + CASE
                     WHEN gnactp.NRTASKSEQ = 1 THEN 'Alta prioridade'
                     WHEN gnactp.NRTASKSEQ = 2 THEN 'Média prioridade'
                     WHEN gnactp.NRTASKSEQ = 3 THEN 'Baixa prioridade'
                     ELSE ''
                 END as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, 1 as quantidade
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs012 prod on form.oid = prod.OIDABCr58ABCzha
left join DYNtbs009 dispfin on dispfin.oid = form.OIDABCjBjABCGzr
where wf.cdprocessmodel=17) sub
