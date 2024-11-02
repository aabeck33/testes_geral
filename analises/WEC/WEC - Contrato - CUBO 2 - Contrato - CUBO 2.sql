SELECT wf.idprocess, gnrev.NMREVISIONSTATUS AS STATUS
, wf.nmprocess
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, format(wf.dtstart,'dd/MM/yyyy') AS dtabertura
, datepart(yyyy,wf.dtstart) AS dtabertura_ano
, datepart(MM,wf.dtstart) AS dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') AS dtfechamento
, datepart(yyyy,wf.dtfinish) AS dtfechamento_ano
, datepart(MM,wf.dtfinish) as dtfechamento_mes
, stru.IDSTRUCT
, stru.NMSTRUCT
, coalesce(his.nmrole, 'Usuário') AS tpexecut
, his.nmuser
, his.nmaction
, CASE WHEN STRu.DTEXECUTION is not null THEN datediff(DD,(cast(STRu.dtenabled AS datetime) + cast(STRu.tmenabled AS DATETIME))
, (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime))) else null end as Tempo
, 1 AS quantidade
FROM DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join WFHISTORY HIS ON his.idprocess = wf.idobject and HIS.FGTYPE IN (9) 
and HIS.DTHISTORY+HIS.TMHISTORY = (
SELECT max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject and his.idstruct = his1.idstruct)
left join wfstruct stru on stru.idobject = his.idstruct
WHERE wf.cdprocessmodel=2808 or wf.cdprocessmodel=2909 or wf.cdprocessmodel=2951
