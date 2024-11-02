Select wf.idprocess, wf.nmprocess, wf.DTSTART, wf.DTFINISH, gnrev.NMREVISIONSTATUS as statusevento
, case wf.fgstatus
when 1 then 'Em andamento'
when 2 then 'Suspenso'
when 3 then 'Cancelado'
when 4 then 'Encerrado'
when 5 then 'Bloqueado para edição'
end as statusprocesso
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtex2 FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject) as dtGQ1
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmGQ1
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtex1 FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject) as dtGQ2
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as nmGQ2
, form.tds009 as descr, form.tds010 as motivo
, coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCIQeABC45y = form.oid FOR XML PATH('')), 4, 40000)), 'NA') as listaprodlote
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as crit
---novo cm
, case form.tds398 when 1 then 'Sim' when 2 then 'Não' end as ImpactoUni
, form.tds397 as unidadesenvolvidas
, case form.tds171 when 1 then 'Sim' when 2 then 'Não' end as cmcliente
, form.tds172 as NumCmCliente
, case form.tds375 when 1 then 'Simples' when 2 then 'Complexa' end as ComplexidadeMudanca
, (Select wf.dtupdate where wf.fgstatus=3) as dtcancel


, 1 as Quantidade
from wfprocess wf
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
left join DYNtds015 form on (gnf.oidentityreg = form.oid)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join gnactivity gnact on wf.CDGENACTIVITY = gnact.CDGENACTIVITY
where cdprocessmodel=1
