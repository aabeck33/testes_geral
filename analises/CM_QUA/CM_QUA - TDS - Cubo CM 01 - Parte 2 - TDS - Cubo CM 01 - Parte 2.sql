Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, case 
            when wf.dtfinish is null then (select max(his.DTHISTORY+his.TMHISTORY)  from wfhistory his 
            where  HIS.FGTYPE = 3 and his.idprocess = wf.idobject and not exists  (select  his1.fgtype from wfhistory his1 
                where  HIS1.FGTYPE = 5  and his1.idprocess = his.idprocess  and his1.DTHISTORY+his1.TMHISTORY  > his.DTHISTORY+his.TMHISTORY)) else wf.dtfinish 
            end as dtfechamento
, form.tds002 as nmterceiro, form.tds017 as nmaprovaremud
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tds107 when 1 then 'Sim' when 2 then 'Não' end as mbr
, case form.tds108 when 1 then 'Melhoria' when 2 then 'Atualização obrigatória' end as tpmbr
, case form.tds109 when 1 then 'Sim' when 2 then 'Não' end as info1lote
, case when form.tds004 = 1 then '' else form.tds005 end as dtinitemp
, case when form.tds004 = 1 then '' else form.tds006 end as dtfimtemp
, case when form.tds004 = 1 then '' else form.tds007 end as lotestemp
, case form.tds004 when 1 then 'Permanente' when 2 then 'Temporária' end as classific
, case form.tds024 when 0 then 'Não' when 1 then 'Sim' end as materialprod
, case form.tds001 when 0 then 'Não' when 1 then 'Sim' end as impactterc
, null as impactcli
, case form.tds013 when 0 then 'Não' when 1 then 'Sim' end as avalcli
, case form.tds003 when 0 then 'Não' when 1 then 'Sim' end as emergencial
, case form.tds112 when 0 then 'Não' when 1 then 'Sim' end as impactliberalote
, case form.tds011 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_validacao
, case form.tds012 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_qualificacao
, case form.tds105 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_estabiliadde
, case form.tds106 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_regulatorio
, areamud.tbs001 as areamudanca, 'NA' as areainiciadora, unid.tbs001 as unidade
, cast(coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCIQeABC45y = form.oid FOR XML PATH('')), 4,99000)), 'NA') as varchar(max)) as listaprodlote --listaprod--
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
, cast(coalesce((select substring((select ' | '+ tds001 +' - '+ tds002 +' - '+ format(tds003,'dd/MM/yyyy') as [text()] from DYNtds043 where OIDABC8eEABCZHc = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as varchar(1000)) as listaregulatórios --listaregulatórios--
, (select substring((
select ' | '+ substring((select nmlabel from EMATTRMODEL where oidentity = (select oid from EMENTITYMODEL where idname = 'tds015') and idname=coluna),10,250) as [text()]
from (select * from dyntds015 where OID = form.oid) s
unpivot (valor for coluna in (tds027, tds028, tds029, tds030, tds031, tds032, tds033, tds034, tds035, tds036, tds037, tds038, tds039, tds040, tds041, tds042, tds043, tds044, tds045, tds046, tds047, tds048, tds049, tds050, tds051, tds052, tds053, tds054, tds055, tds056, tds057, tds058, tds059, tds060, tds061, tds062, tds063, tds064, tds065, tds066, tds104)) as tt
where valor = 1 FOR XML PATH('')), 4, 1000)) as listamudanca
, (select substring((
select ' | '+ substring((select nmlabel from EMATTRMODEL where oidentity = (select oid from EMENTITYMODEL where idname = 'tds015') and idname=coluna),8,250) as [text()]
from (select * from dyntds015 where OID = form.oid) s
unpivot (valor for coluna in (tds067,tds068,tds069,tds070,tds071,tds072,tds073,tds074,tds075,tds076,tds077,tds078,tds079,tds080,tds081,tds082,tds083,tds084,tds085,tds086,tds087,tds088,tds089,tds090,tds091,tds092,tds093,tds094,tds095,tds096,tds097,tds098,tds099,tds100,tds101,tds102,tds103)) as tt
where valor = 1 FOR XML PATH('')), 4, 1000)) as areasaval
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102914347264' and str.idprocess=wf.idobject) as dtsubmis
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmaprov
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject) as dtaprov
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102914543984' and str.idprocess=wf.idobject) as dtencerrou
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade14102914543984' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmencerrou
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
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject) is not null then datediff(mi, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), (SELECT str.DTEXECUTION+str.TMEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject))/1440 else
datediff(dd, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), getdate())/1440 end tpsegaprov
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject) is not null then datediff(mi, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), (SELECT str.DTEXECUTION+str.TMEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject))/1440 else
datediff(dd, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), getdate())/1440 end tppriaprovacao
, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141111113134390' and str.idprocess=wf.idobject) is not null then datediff(mi, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Atividade141111113134390' and str.idprocess=wf.idobject), (SELECT str.DTEXECUTION+str.TMEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade141111113134390' and str.idprocess=wf.idobject))/1440 else
datediff(dd, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Atividade141111113134390' and str.idprocess=wf.idobject), getdate())/1440 end tpaguardacli
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189') and str.idprocess=wf.idobject and str.DTEXECUTION is not null) as dtliberacao
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189') and str.idprocess=wf.idobject and str.idobject = wfa.idobject and str.DTEXECUTION is not null) as nmliberacao
, datediff(dd, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102914347264' and str.idprocess=wf.idobject), (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct in ('Atividade14102914355828', 'Atividade1518102355189') and str.idprocess=wf.idobject and str.DTEXECUTION is not null)) as tempoaceita
, (select count(*) from (SELECT HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY, HIS.NMACTION
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 'Atividade14102914347264'
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (9) and HIS.NMACTION = 'Submeter' and his.idprocess = wf.idobject) his) as qtdciclos
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs039 areamud on areamud.oid = form.OIDABCk8DABCghk
left join DYNtbs001 unid on unid.oid = form.OIDABCVrhABCPrY
where cdprocessmodel=1
