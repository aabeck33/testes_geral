select form.tds005 as Resp_Investigacao,form.tds004 as Resp_AnaliseN1, form.tds001 as DT_deteccao, form.tds002 as DT_Ocorrencia, form.tds003 as DT_LimiteConclusao, form.tds009 as metodo, form.tds011 as teste
, wf.DTFINISH as DTfim, wf.idprocess, wf.nmprocess as Titulo, wf.DSPROCESS as Descricao, wf.dtstart, wf.NMUSERSTART as Iniciador, gnrev.NMREVISIONSTATUS as statuslab
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusprb
, catraiz.tbs007 as catcausaraiz, catev.tbs001 as catevento, laboc.tbs001 as laboratorio
, case form.tds008 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tds031 when 1 then 'Crítico' when 2 then 'Não crítico' end as critfin
, cast(coalesce((select substring((select ' | '+ equipo.tds001 as [text()] from DYNtds016 form1
                 left join DYNtds050 equipo on form1.oid = equipo.OIDABC60YRMLCRJSBK
                 where form1.oid = form.oid
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaequipamentos --listaequipamentos--

, cast(coalesce((select substring((select ' | '+ mat.tbs003 +' - '+ mat.tbs002 +' - '+ mat.tbs004 as [text()] from DYNtds016 form1
                 left join DYNtbs012 mat on form1.oid = mat.OIDABCZNQABCMWP
                 where form1.oid = form.oid
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaMatProcessImpact --Material/Processo impactados--


, cast(coalesce((select substring((select ' | '+ Cliente.tbs001 as [text()] from DYNtds016 form1
                 left join DYNtbs040 Cliente on form1.oid = cliente.OIDABCL234PP0HZVDJ
                 where form1.oid = form.oid
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as ListaCliente --Cliente--


, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = case when (catev.tbs001 = 'SST' or catev.tbs001 = 'OAL') then 'Decisão17517143141313' 
      else 'Decisão17517143228556' end and str.idprocess=wf.idobject) as dtaprfinal

, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade17517142546397' and str.idprocess=wf.idobject) as dtInvestigN1
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade17517142546397' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmInvestigN1

, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject) as dtAprovGQ
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão17517143228556' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmAprovGQ

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
where wf.cdprocessmodel=3237
