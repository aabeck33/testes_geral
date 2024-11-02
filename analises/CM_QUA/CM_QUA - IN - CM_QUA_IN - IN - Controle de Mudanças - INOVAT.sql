Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus
when 1 then 'Em andamento'
when 2 then 'Suspenso'
when 3 then 'Cancelado'
when 4 then 'Encerrado'
when 5 then 'Bloqueado para edição'
end as statusprocesso
, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, (Select wf.dtupdate where wf.fgstatus=3) as dtcancel
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as crit

, case when (coalesce((SELECT MAX(str.DTEXECUTION+str.TMEXECUTION) AS ATV_APPROV2 FROM WFSTRUCT STR
     WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime)) > coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_approv2 FROM WFSTRUCT STR
     WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime))) then 'Aprovar [GQ1]'
         when (coalesce((SELECT MAX(str.DTEXECUTION+str.TMEXECUTION) AS ATV_APPROV2 FROM WFSTRUCT STR
    WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime)) < coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_approv2 FROM WFSTRUCT STR
    WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime))) then 'Aprovar [GQ1] +Aprovar [GQ2]'
               else 'N/A'
                     end atv_approva
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
where cdprocessmodel = 3234
