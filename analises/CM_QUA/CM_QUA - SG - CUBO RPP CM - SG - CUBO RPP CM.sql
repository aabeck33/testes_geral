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
, (Select wf.dtupdate where fgstatus=3) as dtcancel
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as crit
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão14102914536874' and str.idprocess = wf.idobject) as dtaprovGQ1
, (SELECT max(str.DTEXECUTION+str.TMEXECUTION) as dtaprov FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141111113212628' and str.idprocess = wf.idobject) as dtaprovGQ2
, (SELECT top 1 str.nmstruct FROM WFSTRUCT STR
WHERE (str.fgstatus = 2 and str.idprocess = wf.idobject))  as atvAtual
, coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCIQeABC45y = form.oid FOR XML PATH('')), 4, 40000)), 'NA') as listaprodlote
	
, 1 as Quantidade
, form.tds010 as motivmud
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where cdprocessmodel = 5842
