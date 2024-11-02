Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, wf.dtfinish as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, form.tbs004 as dtdeteccao, datepart(yyyy,form.tbs004) as dtdeteccao_ano, datepart(MM,form.tbs004) as dtdeteccao_mes
, form.tbs005 as dtocorrencia, datepart(yyyy,form.tbs005) as dtocorrencia_ano, datepart(MM,form.tbs005) as dtocorrencia_mes
, form.tbs006 as dtlimite, datepart(yyyy,form.tbs006) as dtlimite_ano, datepart(MM,form.tbs006) as dtlimite_mes
, form.tbs002 as respanalisen1, form.tbs037 as respinvestiga, 'NA' as metodo, 'NA' as idamostra, 'NA' as descteste, 'NA' as especific
, catraiz.tbs007 as catcausaraiz, catev.tbs001 as tipo, laboc.tbs001 as laboratorio, unid.tbs001 as unidade
, case form.tbs011 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tbs035 when 1 then 'Crítico' when 2 then 'Não crítico' end as critfin
, case form.tbs029 when 1 then 'Sim' when 2 then 'Não' end as confirmada
, case form.tbs052 when 1 then 'Sim' when 2 then 'Não' end as necessidadeve
, case form.tbs031 when 0 then 'Não' when 1 then 'Sim' end as recorrente
, case form.tbs008 when 0 then 'Não' when 1 then 'Sim' end as ocoremterfornec
, case form.tbs022 when 0 then 'Não' when 1 then 'Sim' end as remedicao
, 'NA' as erroobvio
, 'NA' as extracaoadic
, 'NA' as amostraoriginal
, 'NA' as reamostragem
, 'NA' as aguardaplacao
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then case form.tbs051 when 1 then 'Eficaz' when 2 then 'Não eficaz' else '' end else '' end as eficacia
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade14102895352873' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as investigadorn1
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade1410289542484' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as investigadorn2
, 'NA' as investigadorn3
, case coalesce((SELECT str.FGCONCLUDEDSTATUS FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102895346716' and str.idprocess=wf.idobject), -1) when 1 then 'Aberta no prazo' when 2 then 'Aberta em atraso' else 'NA' end as abertura
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102895346716' and str.idprocess=wf.idobject) as dtsubmissao

, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143141313' and str.idprocess=wf.idobject) as dtaprovaçãoCQ
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject) as dtaprovacaoGQ

, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102895442364' and str.idprocess=wf.idobject) is not null then
datediff (dd, form.tbs004, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102895442364' and str.idprocess=wf.idobject)) else -1 end as conclusao
, (select max(dtexecution) from (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as mexec, str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct in ('Decisão14102895442364', 'Decisão14102895449199') and str.idprocess=wf.idobject group by str.dtexecution) _sub) as dtencerrada
, coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +')' as [text()] from DYNtbs012 where OIDABCVdbABCyvW = form.oid FOR XML PATH('')), 4, 4000)), 'NA') as prodlote --listaprod--
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdactionplan = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, 1 as quantidade
from DYNtbs016 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs025 catev on catev.oid = form.OIDABCi3MABCjEA
left join DYNtbs026 laboc on laboc.oid = form.OIDABCYa3ABCdTh
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABC87ZABCfAP
left join DYNtbs001 unid on unid.oid = form.OIDABCONdABCARv
where wf.cdprocessmodel=38 and wf.fgstatus < 6
union all
Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, wf.dtfinish as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, form.tds001 as dtdeteccao, datepart(yyyy,form.tds001) as dtdeteccao_ano, datepart(MM,form.tds001) as dtdeteccao_mes
, form.tds002 as dtocorrencia, datepart(yyyy,form.tds002) as dtocorrencia_ano, datepart(MM,form.tds002) as dtocorrencia_mes
, form.tds003 as dtlimite, datepart(yyyy,form.tds003) as dtlimite_ano, datepart(MM,form.tds003) as dtlimite_mes
, form.tds004 as respanalisen1, form.tds005 as respinvestiga, form.tds009 as metodo, form.tds010 as idamostra, form.tds011 as descteste, form.tds012 as especific
, catraiz.tbs007 as catcausaraiz, catev.tbs001 as tipo, laboc.tbs001 as laboratorio, unid.tbs001 as unidade
, case form.tds008 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tds031 when 1 then 'Crítico' when 2 then 'Não crítico' end as critfin
, case form.tds025 when 1 then 'Sim' when 2 then 'Não' end as confirmada
, case form.tds032 when 1 then 'Sim' when 2 then 'Não' end as necessidadeve
, case form.tds027 when 0 then 'Não' when 1 then 'Sim' end as recorrente
, case form.tds006 when 0 then 'Não' when 1 then 'Sim' end as ocoremterfornec
, case form.tds018 when 0 then 'Não' when 1 then 'Sim' end as remedicao
, case form.tds045 when 0 then 'Não' when 1 then 'Sim' end as erroobvio
, case form.tds044 when 0 then 'Não' when 1 then 'Sim' end as extracaoadic
, case form.tds048 when 0 then 'Não' when 1 then 'Sim' end as amostraoriginal
, case form.tds049 when 0 then 'Não' when 1 then 'Sim' end as reamostragem
, case form.tds043 when 0 then 'Não' when 1 then 'Sim' end as aguardaplacao
, case gnrev.NMREVISIONSTATUS when 'Encerrado' then coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141028103225870' and str.idprocess=wf.idobject and str.idobject = wfa.idobject),'Eficaz') else '' end as eficaia
, (select NMUSER from (SELECT top 1 max(str.DTEXECUTION+str.TMEXECUTION) as mexec, WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct in ('Atividade14102895352873', 'Atividade17517142546397') and str.idprocess=wf.idobject and str.idobject = wfa.idobject
group by WFA.NMUSER, str.DTEXECUTION+str.TMEXECUTION order by str.DTEXECUTION+str.TMEXECUTION DESC) _sub) as investigadorn1
, (select NMUSER from (SELECT top 1 max(str.DTEXECUTION+str.TMEXECUTION) as mexec, WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct in ('Atividade1410289542484', 'Atividade17517142748315') and str.idprocess=wf.idobject and str.idobject = wfa.idobject
group by WFA.NMUSER, str.DTEXECUTION+str.TMEXECUTION order by str.DTEXECUTION+str.TMEXECUTION DESC) _sub) as investigadorn2
, (select NMUSER from (SELECT top 1 max(str.DTEXECUTION+str.TMEXECUTION) as mexec, WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct in ('Atividade17822182820415') and str.idprocess=wf.idobject and str.idobject = wfa.idobject
group by WFA.NMUSER, str.DTEXECUTION+str.TMEXECUTION order by str.DTEXECUTION+str.TMEXECUTION DESC) _sub) as investigadorn3
, case coalesce((SELECT str.FGCONCLUDEDSTATUS FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102895346716' and str.idprocess=wf.idobject), -1) when 1 then 'Aberta no prazo' when 2 then 'Aberta em atraso' else 'NA' end as abertura
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade14102895346716' and str.idprocess=wf.idobject) as dtsubmissao

, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143141313' and str.idprocess=wf.idobject) as dtaprovaçãoCQ
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject) as dtaprovacaoGQ

, case when (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject) is not null then
datediff (dd, form.tds001, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject)) else -1 end as conclusao
, (select max(dtexecution) from (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as mexec, str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct in ('Decisão17517143228556','Decisão14102895442364', 'Decisão14102895449199') and str.idprocess=wf.idobject group by str.dtexecution) _sub) as dtencerrada
, coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +')' as [text()] from DYNtbs012 where OIDABCZnQABCmWp = form.oid FOR XML PATH('')), 4, 4000)), 'NA') as prodlote --listaprod--
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, 1 as quantidade
from DYNtds016 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs025 catev on catev.oid = form.OIDABCDVEABCirD
left join DYNtbs026 laboc on laboc.oid = form.OIDABCIsOABCqaE
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABCV7YABC5wq
left join DYNtbs001 unid on unid.oid = form.OIDABCcwcABCrcN
where wf.cdprocessmodel=38 and wf.fgstatus < 6
