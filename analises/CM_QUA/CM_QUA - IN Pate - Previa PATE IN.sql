Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus
when 1 then 'Em andamento'
when 2 then 'Suspenso'
when 3 then 'Cancelado'
when 4 then 'Encerrado'
when 5 then 'Bloqueado para edição'
end as statusprocesso
, form.tds173 as novocm
, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, (Select wf.dtupdate where fgstatus=3) as dtcancel
, case form.tds423 when 1 then 'Sim' when 2 then 'Não' end as PreviaReg
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE (str.idstruct = 'Decisão2210485858376' or str.idstruct = 'Decisão2210485858376') and str.idprocess = wf.idobject) as dtPreviaReg
, form.tds178 as AvPreviaReg
, case form.tds174 when 1 then 'Sim' when 2 then 'Não' end as cPate
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE (str.idstruct = 'Decisão221048592236' or str.idstruct =  'Decisão221048592236') and str.idprocess = wf.idobject) as dtCpate
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

	
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where cdprocessmodel = 3234
