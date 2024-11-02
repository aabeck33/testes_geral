Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, form.tbs009 as nmterceiro, form.tbs033 as nmaprovaremud
, case form.tbs030 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, 'NA' as mbr
, 'NA' as tpmbr
, 'NA' as info1lote
, case when form.tbs011 = 1 then '' else format(form.tbs012,'dd/MM/yyyy') end as dtinitemp
, case when form.tbs011 = 1 then '' else format(form.tbs013,'dd/MM/yyyy') end as dtfimtemp
, case when form.tbs011 = 1 then '' else form.tbs014 end as lotestemp
, case form.tbs011 when 1 then 'Permanente' when 2 then 'Temporária' end as classific
, case form.tbs055 when 0 then 'Não' when 1 then 'Sim' end as materialprod
, case form.tbs008 when 0 then 'Não' when 1 then 'Sim' end as impactterc
, case form.tbs022 when 0 then 'Não' when 1 then 'Sim' end as impactcli
, case form.tbs026 when 0 then 'Não' when 1 then 'Sim' end as avalcli
, case form.tbs010 when 0 then 'Não' when 1 then 'Sim' end as emergencial
, case form.tbs020 when 0 then 'Não' when 1 then 'Sim' end as impactliberalote
, 'NA' as tpimpacto_validacao
, 'NA' as tpimpacto_qualificacao
, 'NA' as tpimpacto_estabiliadde
, 'NA' as tpimpacto_regulatorio
, areamud.tbs001 as areamudanca, areaini.tbs001 as areainiciadora, unid.tbs001 as unidade
, cast(coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCFCIABCMH0 = form.oid FOR XML PATH('')), 4, 40000)), 'NA')  as varchar(8000)) as listaprodlote --listaprod--
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity as [text()] from gnactivity gnact
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
, cast(coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs040 where OIDABC1pFABCwh3 = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as varchar(1000)) as listaclientes --listaclientes--
, 'NA' as listaregulatórios
, cast(coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs019 where OIDABCJonABCFKa = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as varchar(1000)) as listamudanca --listamudanca--
, 'NA' as areasaval
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtsubmis
, (select nmuser from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as nmaprov
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtaprov
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
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtencerrou
, datepart(yyyy,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) as dtencerrou_ano
, datepart(MM,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) as dtencerrou_mes
, (select HIS.NMUSER from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914543984'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as nmencerrou
, case when gnrev.NMREVISIONSTATUS = 'Cancelado' then case (SELECT WFA.FGAUTOEXECUTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and WFA.NMEXECUTEDACTION = 'Cancelar' and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and WFA.NMEXECUTEDACTION = 'Cancelar' and his1.idprocess = wf.idobject
)) when 1 then 'Automático na primeira atividade' when 2 then 'Não Automático na primeira atividade' else 'Por solicitação' end
end Cancelamento
, case when (SELECT STR.DTEXECUTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) is not null then datediff(mi,(SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)),(SELECT (cast(STR.DTEXECUTION as datetime) + cast(STR.TMEXECUTION as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)))/1440 else
datediff(mi,(SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão141111113212628'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), getdate())/1440 end tpsegaprov
, case when (SELECT STR.DTEXECUTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) is not null then datediff(mi, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), (SELECT (cast(STR.DTEXECUTION as datetime) + cast(STR.TMEXECUTION as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)))/1440 else
datediff(dd, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Decisão14102914536874'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), getdate())/1440 end tppriaprov
, case when (SELECT STR.DTEXECUTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) is not null then datediff(mi, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), (SELECT (cast(STR.DTEXECUTION as datetime) + cast(STR.TMEXECUTION as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)))/1440 else
datediff(dd, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade14102914459502'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), getdate())/1440 end tpcriaplacao
, case when (SELECT STR.DTEXECUTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) is not null then datediff(mi, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), (SELECT (cast(STR.DTEXECUTION as datetime) + cast(STR.TMEXECUTION as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)))/1440 else
datediff(dd, (SELECT (cast(wfa.dtstart as datetime) + cast(wfa.tmstart as datetime))
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 'Atividade141111113134390'
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)), getdate())/1440 end tpaguardacli
, (select format(HIS.DTHISTORY,'dd/MM/yyyy') from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as dtlibera
, datepart(yyyy,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) ) as dtlibera_ano
, datepart(MM,(select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) ) as dtlibera_mes
, (select HIS.NMUSER from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his) as nmlibera
, datediff(dd, (select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914347264')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914347264')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his), (select HIS.DTHISTORY from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade14102914355828', 'Atividade1518102355189')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject
)) his)) as tempoaceita
, (select count(*) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and HIS.NMACTION = 'Submeter' and his.idprocess = wf.idobject) his) as qtdciclos
, 1 as Quantidade
from DYNtbs015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.CDUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs039 areamud on areamud.oid = form.OIDABCQueABCNDM
left join DYNtbs039 areaini on areaini.oid = form.OIDABC3a2ABCLSW
left join DYNtbs001 unid on unid.oid = form.OIDABCTYWABCE9z
--placao--left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
--placao--left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
--placao--left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
--placao--left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
--adhoc--left join WFSTRUCT wfs on wf.idobject = wfs.idprocess
--adhoc--left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
--adhoc--left join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
--adhoc--left join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
where cdprocessmodel=1
