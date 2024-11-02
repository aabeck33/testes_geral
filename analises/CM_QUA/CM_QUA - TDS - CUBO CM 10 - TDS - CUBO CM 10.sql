Select wf.idprocess, wf.nmprocess, wf.DTSTART, wf.DTFINISH, gnrev.NMREVISIONSTATUS as statusevento
, case wf.fgstatus
    when 1 then 'Em andamento'
    when 2 then 'Suspenso'
    when 3 then 'Cancelado'
    when 4 then 'Encerrado'
    when 5 then 'Bloqueado para edição'
end as statusprocesso
, (SELECT max(str.DTEXECUTION) as dtgqx FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject) as dtGQ1
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmGQ1
, (SELECT max(str.DTEXECUTION) as dtgqx FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject) as dtGQ2
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmGQ2
,  (SELECT max(str.DTEXECUTION) as dtgqam FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914531751' and str.idprocess=wf.idobject) as dtAM
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão14102914531751' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmAM
, case when prodb.tbs002 is null then prodd.tbs002 else prodb.tbs002 end as codigo
, case when prodb.tbs001 is null then prodd.tbs001 else prodb.tbs001 end as descr
, case when prodd.tbs008 is null then case when clid.tbs001 is null then clib.tbs001 else clid.tbs001 end else prodd.tbs008 end as cliente
, gnactp.idactivity as plAcao, aprov.nmuser, convert(varchar(10),aprov.dtapprov, 103) as dataaprova

, case formd.tds375 when 1 then 'Simples' when 2 then 'Complexa' end as ComplexidadeMudanca
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão221048547591' and str.idprocess=wf.idobject) as dtverificacaoeficacia

--, simn.simnao as Mudancaeficaz 

, 1 as Quantidade
from wfprocess wf
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
left join DYNtds015 formd on (gnf.oidentityreg = formd.oid)
left join DYNtbs015 formb on (gnf.oidentityreg = formb.oid)


--left join DYNsimnao simn on simn.OIDABCEKOCACUU9F72 = formd.oid

left outer join gnrevisionstatus gnrs on (wf.cdstatus = gnrs.cdrevisionstatus)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left join DYNtbs024 prodb on prodb.OIDABCFCIABCMH0 = formb.oid
left join DYNtbs040 clib on clib.OIDABC1pFABCwh3 = formb.oid
left join DYNtbs024 prodd on prodd.OIDABCIQeABC45y = formd.oid
left join DYNtbs040 clid on clid.OIDABCtTKABCkFM = formd.oid


left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join gnactivity gnact on wf.CDGENACTIVITY = gnact.CDGENACTIVITY
left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
left join gnvwapprovresp aprov on aprov.cdapprov = gnactp.CDPLANROUTE and cdprod=174
      and ((aprov.fgpend = 2 and aprov.fgapprov=1) or (aprov.fgpend = 1) or (fgpend is null and fgapprov is null))
left join (select max(cdcycle) as maxcycle, cdapprov
      from gnvwapprovresp where cdprod=174
      group by cdapprov) max_cycle on aprov.cdapprov = max_cycle.cdapprov and aprov.cdcycle = max_cycle.maxcycle

where cdprocessmodel=1
