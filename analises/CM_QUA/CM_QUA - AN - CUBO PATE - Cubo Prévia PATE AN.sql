select  wf.IDPROCESS, wf.NMPROCESS, wf.NMUSERSTART
--, form.*
, case when form.tds423 = 1 then 'SIM' when form.tds423 = 2 then 'Não' end as previa_regu
, form.tds178 as aval_prevregul

, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão2210485858376' and str.idprocess = wf.idobject) as dtPreviaReg
, case when form.tds174 = 1 then 'SIM' when form.tds174 = 2 then 'Não' end as comitpate
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão221048592236' and str.idprocess = wf.idobject) as dtComitPate
, substring(
     case form.tds370 when 1 then ' | Implementação imediata [HMP]' when 0 then '' end
  + case form.tds371 when 1 then ' | Implementação após protocolo' when 0 then '' end
  + case form.tds411 when 1 then ' | Implementação imediata [outros países]' when 0 then '' end
  + case form.tds460 when 1 then ' | Implementação após aprovação da agência reguladora [outros países]' when 0 then '' end
  + case form.tds372 when 1 then ' | Implementação após aprovação da ANVISA' when 0 then '' end 
  + case form.tds373 when 1 then ' | Outros [Implementação após notificação]' when 0 then '' end
  + case form.tds461 when 1 then ' | Implementação após protocolo [outros países]' when 0 then '' end
  + case form.tds374 when 1 then ' | Sem impacto regulatório' when 0 then '' end
  + case form.tds449 when 1 then ' | Não Aplicável' when 0 then '' end, 4, 500)
as ImpactoRegulatorioHum
, case 
		when form.tds003 = '0' then (SELECT str.fgstatus FROM WFSTRUCT STR WHERE str.idstruct = 'Complexo3' and str.idprocess = wf.idobject)
		else
			(SELECT str.fgstatus FROM WFSTRUCT STR WHERE str.idstruct = 'Complexo3 [e]' and str.idprocess = wf.idobject)
		end as Avhabilitada
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão221048398751' and str.idprocess = wf.idobject) as dtApvAreaCM

FROM WFPROCESS wf

inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNtds015 form on (gnf.oidentityreg = form.oid)
left outer join gnrevisionstatus gnrs on (wf.cdstatus = gnrs.cdrevisionstatus)
left join DYNsimnao loteenvolvido on loteenvolvido.oid = form.OIDABCHUE6KVRWK8ET
left join DYNtbs001 unid on unid.oid = form.OIDABCVrhABCPrY

INNER JOIN PMACTIVITY PP ON PP.CDACTIVITY = wf.CDPROCESSMODEL
INNER JOIN PMACTTYPE PT ON PT.CDACTTYPE = PP.CDACTTYPE
LEFT OUTER JOIN GNREVISION GREV ON wf.CDREVISION = GREV.CDREVISION
LEFT OUTER JOIN GNACTIVITY GNP ON (wf.CDGENACTIVITY = GNP.CDGENACTIVITY)
LEfT OUTER JOIN GNEVALRESULTUSED GNRUS ON (GNRUS.CDEVALRESULTUSED = GNP.CDEVALRSLTPRIORITY)
lefT OUTER JOIN GNEVALRESULT GNR ON (GNRUS.CDEVALRESULT = GNR.CDEVALRESULT)
inner JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)

left outer join pbproblem pbp on (inc.cdoccurrence = pbp.cdoccurrence)
LEFT OUTER JOIN GNGENTYPE GNT ON (INC.CDOCCURRENCETYPE = GNT.CDGENTYPE)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
where wf.CDGENACTIVITY = GNP.CDGENACTIVITY
and wf.cdprocessmodel =1
