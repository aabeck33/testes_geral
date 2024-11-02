Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus
when 1 then 'Em andamento'
when 2 then 'Suspenso'
when 3 then 'Cancelado'
when 4 then 'Encerrado'
when 5 then 'Bloqueado para edição'
end as statusprocesso
, case when wf.fgstatus = 3 then wf.dtupdate else null end as dtcancel


, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as crit

, (SELECT MAX(str.DTEXECUTION+STR.TMEXECUTION) FROM WFSTRUCT STR WHERE (str.idstruct = 'Decisão14102914536874' OR str.idstruct = 'Decisão14102914536874') and str.idprocess = wf.idobject) as dtReprespGQ1
, (SELECT MAX(str.DTEXECUTION+str.TMEXECUTION) FROM WFSTRUCT STR WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess = wf.idobject) as dtReprespAposClienteGQ2

, case form.tds004 when 1 then 'Permanente' when 2 then 'Temporária' end as class_mud
--, case form.tds375 when 1 then 'Simples' when 2 then 'Complexa' end as Complex_mudanca
--, eficaz.simnao as eficacia

,ar_mud.tbs001 as area_mudanca, form.tds010 as mot_mud
,cast(coalesce((select substring((select ' | '+ tbs002  as [text()]
from DYNtbs024 where OIDABCIQEABC45Y = form.oid FOR XML PATH('')), 4, 8000)), 'N/A') as varchar(8000)) as MAT_IMPACT_COD
,cast(coalesce((select substring((select ' | '+ tbs001  as [text()]
from DYNtbs024 where OIDABCIQEABC45Y = form.oid FOR XML PATH('')), 4, 8000)), 'N/A') as varchar(8000)) as MAT_IMPACT_DESC
,cast(coalesce((select substring((select ' | '+ tbs008  as [text()]
from DYNtbs024 where OIDABCIQEABC45Y = form.oid FOR XML PATH('')), 4, 8000)), 'N/A') as varchar(8000)) as MAT_IMPACT_CLI
, case form.tds013 when 1 then 'SIM' when 2 then 'NÃO' end as nec_aval_cli
, case form.tds013 when 1 then cast(coalesce((select substring((select ' | '+ tbs001  as [text()]
from DYNtbs040 where OIDABCTTKABCKFM = form.oid FOR XML PATH('')), 4, 8000)), 'N/A') as varchar(8000)) 
when 0 then 'N/A' end as cliente

, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE (str.idstruct = 'Decisão14102914536874' or str.idstruct = 'Decisão141111113212628')and str.idprocess=wf.idobject) as dtaprov
, gnactp.idactivity as idplano
, case when exists (select 1 from gnactivity where cdactivityowner = gnactp.cdgenactivity and fgstatus <= 3 and dtfinish is null and dtfinishplan < getdate()) then 'Atraso'
when exists (select 1 from gnactivity where cdactivityowner = gnactp.cdgenactivity and fgstatus <= 3 and dtfinish is null and dtfinishplan >= getdate()) then 'Em dia'
else 'N/A'
end as prazopl
, case gnactp.fgstatus
when 1 then 'Planejamento'
when 2 then 'Aprovação do planejamento'
when 3 then 'Execução'
when 4 then 'Verificação da eficácia / Aprovação da execução'
when 5 then 'Encerrado'
WHEN 6 THEN 'Cancelado'
WHEN 7 THEN 'Cancelado'
WHEN 8 THEN 'Cancelado'
WHEN 9 THEN 'Cancelado'
WHEN 10 THEN 'Cancelado'
WHEN 11 THEN 'Cancelado'
else 'N/A'
end as statuspl
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity

left join DYNtbs039 ar_mud on ar_mud.oid = form.OIDABCK8DABCGHK
--left join DYNsimnao eficaz on form.OIDABCEKOCACUU9F72 = eficaz.oid PROJETO
where cdprocessmodel = 3234
