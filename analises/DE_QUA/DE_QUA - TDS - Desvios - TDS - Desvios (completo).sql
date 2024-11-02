Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, 'NA' as repqualidade
, case form.tbs027 when 1 then 'Sim' when 2 then 'Não' end as lotebloq
, case form.tbs028 when 1 then 'Sim' when 2 then 'Não' end as procbloq
, case form.tbs041 when 1 then 'Sim' when 2 then 'Não' end as capa
, case form.tbs080 when 1 then 'Sim' when 2 then 'Não' end as clientefinal
, case form.tbs055 when 1 then 'Sim' when 2 then 'Não' end as relprod
, case when (form.tbs072 = 1 OR form.tbs073 = 1 OR form.tbs074 = 1 OR form.tbs075 = 1 OR form.tbs076 = 1) then 'Sim' 
       when (form.tbs072 = 2 OR form.tbs073 = 2 OR form.tbs074 = 2 OR form.tbs075 = 2 OR form.tbs076 = 2) then 'Não' end as hse
, case form.tbs072 when 1 then 'Sim' when 2 then 'Não' end as hse1
, case form.tbs073 when 1 then 'Sim' when 2 then 'Não' end as hse2
, case form.tbs074 when 1 then 'Sim' when 2 then 'Não' end as hse3
, case form.tbs075 when 1 then 'Sim' when 2 then 'Não' end as hse4
, case form.tbs076 when 1 then 'Sim' when 2 then 'Não' end as hse5
, case form.tbs048 when 1 then 'Sim' when 2 then 'Não' end as verifeficacia
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then case form.tbs081 when 1 then 'Eficaz' when 2 then 'Não eficaz' else '' end else '' end as eficacia
, case form.tbs030 when 0 then 'Não' when 1 then 'Sim' end recorrente
, case form.tbs016 when 0 then 'Não' when 1 then 'Sim' end provterceiro
, case form.aguardapl when 0 then 'Não' when 1 then 'Sim' end aguardapl
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, format(form.tbs012,'dd/MM/yyyy') as dtdeteccao, datepart(yyyy,form.tbs012) as dtdeteccao_ano, datepart(MM,form.tbs012) as dtdeteccao_mes
, format(form.tbs013,'dd/MM/yyyy') as dtocorrencia, datepart(yyyy,form.tbs013) as dtocorrencia_ano, datepart(MM,form.tbs013) as dtocorrencia_mes
, format(form.tbs014,'dd/MM/yyyy') as dtlimite, datepart(yyyy,form.tbs014) as dtlimite_ano, datepart(MM,form.tbs014) as dtlimite_mes
, form.tbs017 as nometerceiro, form.tbs039 as loteterceiro, form.tbs057 as justrelprod
, case when form.tbs012 is not null then datediff(dd, cast(format(form.tbs012,'yyyy/MM/dd') as date), cast(format(wf.dtstart,'yyyy/MM/dd') as date)) else -1 end as tempabertura
, case when case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date), getdate()) end > 25 then 'Em atraso' else 'Em dia' end as prazoproc
, case when case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date), getdate()) end > 3 then 'Em atraso' else 'Em dia' end as prazoabertura
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempoaprovinicial
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempoaprovfinal
, case when (case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tbs012,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end) > 30 then 'Em atraso' else 'Em dia' end as tempoaprovfinalc
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null and (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), (select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempototinvestiga
, 'NA' as prazoanaliscli
, cast(coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +')' as [text()] from DYNtbs012 where OIDABCBZmABCZOW = form.oid FOR XML PATH('')), 4, 8000)), 'NA') as varchar(8000)) as prodlote --listaprod--
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
, catraiz.tbs007 as catcausaraiz, equipo.tbs013 as equipamento, dispfin.tbs009 as disposfinal, classfin.tbs002 as classfin, unid.tbs001 as unidade, 'NA' clienteafetado
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial
, (select datepart(yyyy,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial_ano
, (select datepart(MM,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial_mes
, (select nmuser from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as nmaprovinicial
, datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Rejeitar'
) and his.nmaction = 'Rejeitar') his),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Aprovar'
) and his.nmaction = 'Aprovar') his)) as ciclorejinicial
, (select count(his.nmaction) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject) his where his.nmaction = 'Rejeitar') as regaprovinicial
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal
, (select datepart(yyyy,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal_ano
, (select datepart(MM,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal_mes
, datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Rejeitar'
) and his.nmaction = 'Rejeitar') his),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Aprovar'
) and his.nmaction = 'Aprovar') his)) as ciclorejinfinal
, (select count(his.nmaction) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject) his where his.nmaction = 'Rejeitar') as regaprovfinal
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113051875'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113051875'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtsubmeteregistro
, coalesce((select HIS.NMUSER from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), form.tbs044) as investigador
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtinvestigador
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113659651'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113659651'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtareaacorr
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615355993'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615355993'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtpuverde
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153513122'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153513122'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtpuamarela
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153516481'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153516481'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqfisicoquim
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153519931'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153519931'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqmicrobio
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153521833'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153521833'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqmatemb
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153523510'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153523510'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dthse
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153525165'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153525165'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtfiscal
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153526920'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153526920'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtestab
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153529862'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153529862'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtplanej
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153531348'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153531348'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtdeposit
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153533198'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153533198'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dteng
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615353578'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615353578'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtped
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615353895'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615353895'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtvalmetana
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153540364'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153540364'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtvalida
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153542651'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153542651'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtti
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153554750'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153554750'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtbpf
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153557102'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153557102'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtsgq
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
from DYNtbs010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs011 areadetec on areadetec.oid = form.OIDABCDfwABC5KU
left join DYNtbs011 areaocor on areaocor.oid = form.OIDABCM6gABCRMJ
left join DYNtbs005 classinic on classinic.oid = form.OIDABCbhdABCcG4
left join DYNtbs006 catevent on catevent.oid = form.OIDABCPnPABCtlj
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABC3i7ABC2fm
left join DYNtbs013 equipo on equipo.oid = form.OIDABCcotABCnUs
left join DYNtbs009 dispfin on dispfin.oid = form.OIDABCInNABCCBb
left join DYNtbs002 classfin on classfin.oid = form.OIDABClGPABCiPe
left join DYNtbs001 unid on unid.oid = form.OIDABCoXzABC5KA
--prod--left join DYNtbs012 prod on form.oid = prod.OIDABCBZmABCZOW
--placao--left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
--placao--left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
--placao--left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
--placao--left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
--adhoc--left join WFSTRUCT wfs on wf.idobject = wfs.idprocess
--adhoc--left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
--adhoc--left join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
--adhoc--left join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
where wf.cdprocessmodel=17
union all
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
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then coalesce ((select his.nmuser from (
SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113926692'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject and HIS.DTHISTORY+HIS.TMHISTORY = (
SELECT max(HIS2.DTHISTORY+HIS2.TMHISTORY)
FROM WFHISTORY HIS2
inner JOIN WFSTRUCT STR2 ON HIS2.IDSTRUCT=STR2.IDOBJECT and str2.idstruct = 'Decisão141027113926692'
LEFT OUTER JOIN WFACTIVITY WFA2 ON STR2.IDOBJECT = WFA2.IDOBJECT
WHERE  HIS2.FGTYPE IN (9) and his2.idprocess = wf.idobject
)) his),'Eficaz') else 'NA' end as eficacia
, case form.tds052 when 1 then 'Sim' when 2 then 'Não' end recorrente
, case form.tds006 when 0 then 'Não' when 1 then 'Sim' end provterceiro
, case form.tds042 when 0 then 'Não' when 1 then 'Sim' end aguardapl
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, format(form.tds001,'dd/MM/yyyy') as dtdeteccao, datepart(yyyy,form.tds001) as dtdeteccao_ano, datepart(MM,form.tds001) as dtdeteccao_mes
, format(form.tds002,'dd/MM/yyyy') as dtocorrencia, datepart(yyyy,form.tds002) as dtocorrencia_ano, datepart(MM,form.tds002) as dtocorrencia_mes
, format(form.tds003,'dd/MM/yyyy') as dtlimite, datepart(yyyy,form.tds003) as dtlimite_ano, datepart(MM,form.tds003) as dtlimite_mes
, form.tds007 as nometerceiro, form.tds008 as loteterceiro, form.tds010 as justrelprod
, case when form.tds001 is not null then datediff(dd, cast(format(form.tds001,'yyyy/MM/dd') as date), cast(format(wf.dtstart,'yyyy/MM/dd') as date)) else -1 end as tempabertura
, case when case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date), getdate()) end > 25 then 'Em atraso' else 'Em dia' end as prazoproc
, case when case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date), getdate()) end > 3 then 'Em atraso' else 'Em dia' end as prazoabertura
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempoaprovinicial
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempoaprovfinal
, case when(case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,cast(format(form.tds001,'yyyy/MM/dd') as date),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end) > 30 then 'Em atraso' else 'Em dia' end as tempoaprovfinalc
, case when (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null and (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) is not null then datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), (select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) else -1 end as tempototinvestiga
, case (select his.FGCONCLUDEDSTATUS from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION, str.FGCONCLUDEDSTATUS
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade1571413144783'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade1571413144783'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) when 1 then 'Em dia' when 2 then 'Em atraso' end as prazoanaliscli
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
, catraiz.tbs007 as catcausaraiz, equipo.tbs013 as equipamento, dispfin.tbs009 as disposfinal, classfin.tbs002 as classfin, unid.tbs001 as unidade, cliafet.tbs001 as clienteafetado
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial
, (select datepart(yyyy,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial_ano
, (select datepart(MM,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovinicial_mes
, (select nmuser from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as nmaprovinicial
, datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Rejeitar'
) and his.nmaction = 'Rejeitar') his),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Aprovar'
) and his.nmaction = 'Aprovar') his)) as ciclorejinicial
, (select count(his.nmaction) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113057548'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject) his where his.nmaction = 'Rejeitar') as regaprovinicial
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal
, (select datepart(yyyy,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal_ano
, (select datepart(MM,HIS.DTHISTORY) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprovfinal_mes
, datediff(dd,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Rejeitar'
) and his.nmaction = 'Rejeitar') his),(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his1.nmaction = 'Aprovar'
) and his.nmaction = 'Aprovar') his)) as ciclorejinfinal
, (select count(his.nmaction) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113714228'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject) his where his.nmaction = 'Rejeitar') as regaprovfinal
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113051875'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113051875'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtsubmeteregistro
, coalesce((select HIS.NMUSER from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), form.tds004) as investigador
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141027113146417'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), form.tds004) as dtinvestigador
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141027113659651'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141027113659651'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtareaacorr
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615355993'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615355993'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtpuverde
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153513122'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153513122'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtpuamarela
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153516481'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153516481'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqfisicoquim
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153519931'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153519931'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqmicrobio
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153521833'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153521833'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtcqmatemb
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153523510'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153523510'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dthse
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153525165'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153525165'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtfiscal
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153526920'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153526920'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtestab
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153529862'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153529862'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtplanej
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153531348'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153531348'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtdeposit
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153533198'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153533198'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dteng
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615353578'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615353578'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtped
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão1571615353895'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão1571615353895'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtvalmetana
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153540364'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153540364'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtvalida
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153542651'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153542651'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtti
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153554750'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153554750'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtbpf
, coalesce((select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão15716153557102'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão15716153557102'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), 'NA') as dtsgq
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
