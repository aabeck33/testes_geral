Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura, wf.dtfinish as dtfechamento, form.tds001 as dtdeteccao, form.tds002 as dtocorrencia, form.tds003 as dtlimite
, classinic.tbs005 as classificini, catevent.tbs006 as catevento, classfin.tbs002 as classfim, catraiz.tbs007 as catcausaraiz
, areaocor.tbs11 as areaocorrencia
, case form.tds052 when 1 then 'Sim' when 2 then 'Não' end recorrente
, case form.tds039 when 1 then 'Sim' when 2 then 'Não' end Necessidade_Capa
, case form.tds030 when 1 then 'Sim' when 2 then 'Não' end as lotebloq
, case form.tds044 when 1 then 'Sim' when 2 then 'Não' end as verifeficacia
, case form.tds006 when 0 then 'Não' when 1 then 'Sim' end provterceiro, form.tds007 as nometerceiro, form.tds008 as loteterceiro
, case form.tds009 when 1 then 'Sim' when 2 then 'Não' end as relprod, form.tds010 as justrelprod
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess = wf.idobject) as dtaprovinicial
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess = wf.idobject and str.idobject = wfa.idobject) as nmaprovinicial
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess = wf.idobject and str.idobject = wfa.idobject), form.tds004) as nmaprovfim
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess = wf.idobject) as dtaprovfim
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess = wf.idobject and str.idobject = wfa.idobject), form.tds004) as nminvestiga
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess = wf.idobject) as dtinvestiga
, (SELECT str.DTESTIMATEDFINISH FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess = wf.idobject) as pzinvestiga
, case when cliafet.tbs001 is null then (cast(coalesce((select substring((select ' | '+ cliafet1.tbs001 as [text()] from DYNtbs040 cliafet1
where form.oid = cliafet1.OIDABC5M99RTZHBWXW FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000))) else cliafet.tbs001 end as clienteafetado
, cast(coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +')' as [text()]
from DYNtbs012 where OIDABCr58ABCzha = form.oid FOR XML PATH('')), 4, 8000)), 'NA') as varchar(8000)) as prodlote --listaprod--
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
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then coalesce((select nmuser from (SELECT top 1 max(HIS.TMHISTORY) as maxtime, his.NMUSER
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113926692' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and HIS.DTHISTORY = (
select max(HIS1.DTHISTORY)
FROM WFHISTORY HIS1
WHERE HIS1.IDSTRUCT = STR.IDOBJECT and his1.idprocess = wf.idobject and HIS1.FGTYPE = 9)
group by his.DTHISTORY, his.TMHISTORY, his.NMUSER
order by his.TMHISTORY DESC) _sub),'Eficaz') else 'NA' end as eficacia
, case form.tds042 when 0 then 'Não' when 1 then 'Sim' end aguardapl
, equipo.tbs013 as equipamento
, 1 as quantidade
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNtbs005 classinic on classinic.oid = form.OIDABCCM0ABCSbb
left join DYNtbs006 catevent on catevent.oid = form.OIDABCV3fABC895
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABChG0ABCjLn
left join DYNtbs037 cliafet on cliafet.oid = form.OIDABCGpkABCxJ0
left join DYNtbs002 classfin on classfin.oid = form.OIDABC4sfABC3Qp
left join DYNtbs011 areaocor on areaocor.oid = form.OIDABCO2wABCqaO
left join DYNtbs013 equipo on equipo.oid = form.OIDABCx5sABCIJb
where wf.cdprocessmodel = 5843
