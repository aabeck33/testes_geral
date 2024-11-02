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
, case when (coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_appr FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime)) > coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_appr2 FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime))) then 'Aprovar [GQ1]' 
when (coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_appr FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime)) = coalesce((SELECT max(str.DTEXECUTION+str.TMEXECUTION) as atv_appr2 FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess=wf.idobject), cast('1970-01-01' as datetime))) then 'N/A' 
else 'Aprovar [GQ2]'
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
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as criticidade
, case form.tds398 when 1 then 'Sim' when 2 then 'Não' end as ImpactoUni
, form.tds397 as unidadesenvolvidas
, case form.tds171 when 1 then 'Sim' when 2 then 'Não' end as cmcliente
, form.tds172 as NumCmCliente
, case form.tds375 when 1 then 'Simples' when 2 then 'Complexa' end as ComplexidadeMudanca
, substring(
   case form.tds194 when 1 then ' | Medicamento Humana' when 0 then '' end
 + case form.tds191 when 1 then ' | Cosméticos' when 0 then '' end
 + case form.tds188 when 1 then ' | Alimentos' when 0 then '' end
 + case form.tds189 when 1 then ' | Medicamento Animal' when 0 then '' end
 + case form.tds195 when 1 then ' | Produtos para saúde' when 0 then '' end
 + case form.tds190 when 1 then ' | Não Aplicável' when 0 then '' end
 + case form.tds197 when 1 then ' | Outros '+ form.tds356 when 0 then '' end, 4, 500)
 as catProdimpactados
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
as ImpactoRegulatorio
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão221048547591' and str.idprocess=wf.idobject) as dtverificacaoeficacia
,  simn.simnao as Mudancaeficaz 

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
left join DYNsimnao simn on simn.oid = form.OIDABCEKOCACUU9F72


where cdprocessmodel = 5842
