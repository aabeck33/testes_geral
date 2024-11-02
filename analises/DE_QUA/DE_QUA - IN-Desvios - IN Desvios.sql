Select wf.idprocess, wf.DSPROCESS as DescricaoP,wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess, form.tds004 as investigador
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, form.tds001 as dtdeteccao
, form.tds002 as dtocorrencia
, form.tds003 as dtlimite
, form.tds016 as Requisito_N_atendido, form.tds012 as descricao_detalhada_evento, form.tds022 as Dep_notificados, form.tds023 as Acoes_imediata, form.tds027 as Rac_class_evento
, form.tds032 as acao_imediat_adicionais, form.tds034 as aval_recorrencia, form.tds038 as aval_imptac_abrang, form.tds105 as desc_investigacao,  form.tds037 as concl_investigacao
,  form.tds049 as Coment_s_aprovacao, form.tds129 as DE_Relacionado

--falta incluir novos camposFormulário  ›  QUA010 - DE - Completo / Complete     |     tds010 - Desvio - DE

, areadetec.tbs11 as areadetec, areaocor.tbs11 as areaocorrencia, form.tds071 as repqualidade
, cast(coalesce((select substring((select ' | '+ tbs003 +' - '+ tbs002 +' ('+ tbs004 +') - '+ coalesce(tbs001,'NA') as [text()] from DYNtbs012 where OIDABCr58ABCzha = form.oid FOR XML PATH('')), 4, 8000)), 'NA') as varchar(8000)) as prodlote --listaprod--
, classinic.tbs005 as classificini, catevent.tbs006 as catevento

, catraiz.tbs007 as catcausaraiz, classfin.tbs002 as classfin
, cast(coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs040 where OIDABC5M99RTZHBWXW = form.oid FOR XML PATH('')), 4, 8000)), 'NA') as varchar(8000)) as listacli --listaclientes--
, 1 as quantidade
--INCLUSAO DA DATA DE EXECUÇÃO E APROVADOR DA ATIVIDADE DO PROCESSO.
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Atividade1571413144783' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as Aguard_aval_cliente
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade1571413144783' and str.idprocess=wf.idobject) as dt_exe_aguard_aval_cliente
--AREA DA OCORRENCIA
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113659651' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as Apv_area_ocorrencia
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113659651' and str.idprocess=wf.idobject) as dt_apv_area_ocorrencia
--AREA DA QUALIDADE
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão17822143821284' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as Apv_OPER_Qualidade
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão17822143821284' and str.idprocess=wf.idobject) as dt_Oper_Qualidade
--AREA GARANTIDA DA QUALIDADE
, coalesce((SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject and str.idobject = wfa.idobject), form.tds004) as Apv_Gar_Qualidade
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) as dt_Gar_Qualidade
--AREA OCASIONADORA (CHAMADO 202302130)
--,oca.tbs11 as areacoasionadora
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
--inner join DYNtbs011 oca on oca.oid = form.OIDABC3N8FX4QYR0ND
left join DYNtbs011 areadetec on areadetec.oid = form.OIDABC1moABCe0S
left join DYNtbs011 areaocor on areaocor.oid = form.OIDABCO2wABCqaO
left join DYNtbs005 classinic on classinic.oid = form.OIDABCCM0ABCSbb
left join DYNtbs006 catevent on catevent.oid = form.OIDABCV3fABC895
left join DYNtbs007 catraiz on catraiz.oid = form.OIDABChG0ABCjLn
left join DYNtbs002 classfin on classfin.oid = form.OIDABC4sfABC3Qp
where wf.cdprocessmodel=3235
