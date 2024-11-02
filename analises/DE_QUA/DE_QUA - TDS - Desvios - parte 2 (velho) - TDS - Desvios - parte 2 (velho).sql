Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, form.tds071 as repqualidade
, case form.tds030 when 1 then 'Sim' when 2 then 'Não' end as lotebloq
, case form.tds031 when 1 then 'Sim' when 2 then 'Não' end as procbloq
, case form.tds039 when 1 then 'Sim' when 2 then 'Não' end as capa
, 'NA' as clientefinal
, case form.tds009 when 1 then 'Sim' when 2 then 'Não' end as relprod
, case when (form.tds017 = 1 OR form.tds018 = 1 OR form.tds019 = 1 OR form.tds020 = 1 OR form.tds021 = 1) then 'Sim' 
       when (form.tds017 = 2 OR form.tds018 = 2 OR form.tds019 = 2 OR form.tds020 = 2 OR form.tds021 = 2) then 'Não' end as hse
, case form.tds017 when 1 then 'Sim' when 2 then 'Não' end as hse1
, case form.tds018 when 1 then 'Sim' when 2 then 'Não' end as hse2
, case form.tds019 when 1 then 'Sim' when 2 then 'Não' end as hse3
, case form.tds020 when 1 then 'Sim' when 2 then 'Não' end as hse4
, case form.tds021 when 1 then 'Sim' when 2 then 'Não' end as hse5
, case form.tds044 when 1 then 'Sim' when 2 then 'Não' end as verifeficacia
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113926692' and str.idprocess = wf.idobject and str.idobject = wfa.idobject),
      'Eficaz') else 'NA' end as eficacia
, case form.tds052 when 1 then 'Sim' when 2 then 'Não' end recorrente
, case form.tds006 when 0 then 'Não' when 1 then 'Sim' end provterceiro
, case form.tds042 when 0 then 'Não' when 1 then 'Sim' end aguardapl
, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, form.tds001 as dtdeteccao
, form.tds002 as dtocorrencia
, form.tds003 as dtlimite
, form.tds007 as nometerceiro, form.tds008 as loteterceiro, form.tds010 as justrelprod
, case when form.tds001 is not null then datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), cast(format(wf.dtstart,'yyyy/MM/dd') as date)) else -1 end as tempabertura
, case when case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) is not null then 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject)) else 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), getdate()) end > 25 then 'Em atraso' else 'Em dia' end as prazoproc
, case when case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject) is not null then 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject)) else 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), getdate()) end > 3 then 'Em atraso' else 'Em dia' end as prazoabertura
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject) is not null then 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject)) else -1 end as tempoaprovinicial
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) is not null then 
      datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject)) else -1 end as tempoaprovfinal

--INCLUSÃO DO APROVADOR FINAL E A DATA DE EXECUÇÃO
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as aprovadorfim
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) as dtaprovacaofim

, case when (case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) is not null then 
      datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject)) else -1 end) > 30 then 'Em atraso' else 'Em dia' end as tempoaprovfinalc
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject) is not null and 
(SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) is not null then 
      datediff(dd, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject)) else -1 end as tempototinvestiga
, case (SELECT str.FGCONCLUDEDSTATUS FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade1571413144783' and str.idprocess=wf.idobject) when 1 then 'Em dia' when 2 then 'Em atraso' end as prazoanaliscli
, cast(coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +')' as [text()] from DYNtbs012 where OIDABCr58ABCzha = form.oid FOR XML PATH('')), 4, 8000)), 'NA') as varchar(8000)) as prodlote --listaprod--
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
, cast(coalesce((select substring((select ' | '+ gnact.nmactivity +' / '+ case gnact.fgstatus
    when 5 then 'Executada'
    when 3 then 'Pendente'
  end +' / '+
  case
    when gnact.fgexecutertype= 1 then (select nmuser from aduser where cduser = gnact.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is not null
      then (select nmuser from aduser where cduser = wfa.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is null
      then (select nmrole from adrole where cdrole = gnact.cdrole)
    else 'n/a'
  end +' / '+ gnactowner.nmactivity as [text()] from WFSTRUCT wfs
                                                               left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
                                                               left join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
                                                               left join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
                where wf.idobject = wfs.idprocess
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaadhoc --listaadhoc--
, areadetec.tbs11 as areadetec, areaocor.tbs11 as areaocorrencia, classinic.tbs005 as classificini, catevent.tbs006 as catevento
, catraiz.tbs007 as catcausaraiz, equipo.tbs013 as equipamento, dispfin.tbs009 as disposfinal, classfin.tbs002 as classfin, unid.tbs001 as unidade
--CONCATENAR CLIENTE AFETADO DO CAMPA IMPUT COM O VALOR DA GRID
, case when cliafet.tbs001 is null then (cast(coalesce((select substring((select ' | '+ cliafet1.tbs001 as [text()] from DYNtbs040 cliafet1
   where form.oid = cliafet1.OIDABC5M99RTZHBWXW FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000))) else cliafet.tbs001 end as clienteafetado

, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject) as dtaprovinicial
--
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmaprovinicial
, datediff(dd, (select dthistory from (SELECT max(HIS.TMHISTORY) as maxtime, his.DTHISTORY
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and HIS.DTHISTORY = (
select max(HIS1.DTHISTORY)
FROM WFHISTORY HIS1
WHERE HIS1.IDSTRUCT = STR.IDOBJECT and his1.idprocess = wf.idobject and HIS1.FGTYPE = 9 and his1.nmaction = 'Rejeitar')
and his.nmaction = 'Rejeitar' group by his.DTHISTORY) _sub), (select dthistory from (SELECT max(HIS.TMHISTORY) as maxtime, his.DTHISTORY
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and HIS.DTHISTORY = (
select max(HIS1.DTHISTORY)
FROM WFHISTORY HIS1
WHERE HIS1.IDSTRUCT = STR.IDOBJECT and his1.idprocess = wf.idobject and HIS1.FGTYPE = 9 and his1.nmaction = 'Aprovar')
and his.nmaction = 'Aprovar' group by his.DTHISTORY) _sub)) as ciclorejinicial
, (SELECT count(his.nmaction)
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113057548' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9
and his.nmaction = 'Rejeitar') as regaprovinicial
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) as dtaprovfinal
, datediff(dd, (select dthistory from (SELECT max(HIS.TMHISTORY) as maxtime, his.DTHISTORY
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and HIS.DTHISTORY = (
select max(HIS1.DTHISTORY)
FROM WFHISTORY HIS1
WHERE HIS1.IDSTRUCT = STR.IDOBJECT and his1.idprocess = wf.idobject and HIS1.FGTYPE = 9 and his1.nmaction = 'Rejeitar')
and his.nmaction = 'Rejeitar' group by his.DTHISTORY) _sub), (select dthistory from (SELECT max(HIS.TMHISTORY) as maxtime, his.DTHISTORY
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and HIS.DTHISTORY = (
select max(HIS1.DTHISTORY)
FROM WFHISTORY HIS1
WHERE HIS1.IDSTRUCT = STR.IDOBJECT and his1.idprocess = wf.idobject and HIS1.FGTYPE = 9 and his1.nmaction = 'Aprovar')
and his.nmaction = 'Aprovar' group by his.DTHISTORY) _sub)) as ciclorejinfinal
, (SELECT count(his.nmaction)
FROM WFSTRUCT STR, WFHISTORY HIS
WHERE  str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject
and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9
and his.nmaction = 'Rejeitar') as regaprovfinal
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141027113051875' and str.idprocess=wf.idobject) as dtsubmeteregistro
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as investigador
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess=wf.idobject) as dtinvestigador
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113659651' and str.idprocess=wf.idobject) as dtareaacorr
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão1571615355993' and str.idprocess=wf.idobject) as dtpuverde
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153513122' and str.idprocess=wf.idobject) as dtpuamarela
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153516481' and str.idprocess=wf.idobject) as dtcqfisicoquim
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153519931' and str.idprocess=wf.idobject) as dtcqmicrobio
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153521833' and str.idprocess=wf.idobject) as dtcqmatemb
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153523510' and str.idprocess=wf.idobject) as dthse
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153525165' and str.idprocess=wf.idobject) as dtfiscal
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153526920' and str.idprocess=wf.idobject) as dtestab
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153529862' and str.idprocess=wf.idobject) as dtplanej
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153531348' and str.idprocess=wf.idobject) as dtdeposit
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153533198' and str.idprocess=wf.idobject) as dteng
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão1571615353578' and str.idprocess=wf.idobject) as dtped
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão1571615353895' and str.idprocess=wf.idobject) as dtvalmetana
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153540364' and str.idprocess=wf.idobject) as dtvalida
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153542651' and str.idprocess=wf.idobject) as dtti
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153554750' and str.idprocess=wf.idobject) as dtbpf
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão15716153557102' and str.idprocess=wf.idobject) as dtsgq
--prod--, prod.tbs003 as codprod, prod.tbs002 as descprod, prod.tbs004 as lotes
--placao--, gnactp.idactivity as idplano
/* adhoc
, gnact.nmactivity, case gnact.fgstatus
    when 5 then 'Executada'
    when 3 then 'Pendente'
  end as status
, case
    when gnact.fgexecutertype= 1 then (select nmuser from aduser where cduser = gnact.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is not null
      then (select nmuser from aduser where cduser = wfa.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is null
      then (select nmrole from adrole where cdrole = gnact.cdrole)
    else 'n/a'
  end as executor
, gnactowner.nmactivity as nmactowner
*/
, 1 as quantidade
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs011 areadetec on areadetec.oid = form.OIDABC1moABCe0S
left join DYNtbs011 areaocor on areaocor.oid = form.OIDABCO2wABCqaO
left join DYNtbs005 classinic on classinic.oid = form.OIDABCCM0ABCSbb
left join DYNtbs006 catevent on catevent.oid = form.OIDABCV3fABC895
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABChG0ABCjLn
left join DYNtbs037 cliafet on cliafet.oid = form.OIDABCGpkABCxJ0
left join DYNtbs013 equipo on equipo.oid = form.OIDABCx5sABCIJb
left join DYNtbs009 dispfin on dispfin.oid = form.OIDABCjBjABCGzr
left join DYNtbs002 classfin on classfin.oid = form.OIDABC4sfABC3Qp
left join DYNtbs001 unid on unid.oid = form.OIDABCNyxABCtag
--prod--left join DYNtbs012 prod on form.oid = prod.OIDABCr58ABCzha
--placao--left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
--placao--left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
--placao--left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
--placao--left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
--adhoc--left join WFSTRUCT wfs on wf.idobject = wfs.idprocess
--adhoc--left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
--adhoc--left join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
--adhoc--left join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
where wf.cdprocessmodel=17
