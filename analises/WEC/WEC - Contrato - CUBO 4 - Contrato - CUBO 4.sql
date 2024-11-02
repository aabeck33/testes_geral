SELECT wf.idprocess, gnrev.NMREVISIONSTATUS AS STATUS, wf.nmprocess
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, format(wf.dtstart,'dd/MM/yyyy') AS dtabertura
, format(wf.dtfinish,'dd/MM/yyyy') AS dtfechamento
, his.nmuser
, his.nmaction
, (select top 1 (cast(his1.dthistory as datetime) + cast(his1.tmhistory as datetime))
   from wfhistory his1
   where his1.idprocess = his.idprocess and his1.idstruct = his.idstruct and his1.DTHISTORY+his1.tmhistory < his.dthistory+his.tmhistory
   and his1.fgtype = 6
   order by his1.dthistory+his1.tmhistory desc) as liberado
, (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime)) as executado
, (DATEDIFF(dd, (select top 1 (cast(his1.dthistory as datetime) + cast(his1.tmhistory as datetime))
   from wfhistory his1
   where his1.idprocess = his.idprocess and his1.idstruct = his.idstruct and his1.DTHISTORY+his1.tmhistory < his.dthistory+his.tmhistory
   and his1.fgtype = 6
   order by his1.dthistory+his1.tmhistory desc), (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime))) + 1) as tempo_cd
, (DATEDIFF(dd, (select top 1 (cast(his1.dthistory as datetime) + cast(his1.tmhistory as datetime))
   from wfhistory his1
   where his1.idprocess = his.idprocess and his1.idstruct = his.idstruct and his1.DTHISTORY+his1.tmhistory < his.dthistory+his.tmhistory
   and his1.fgtype = 6
   order by his1.dthistory+his1.tmhistory desc), (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime))) + 1)
  -(DATEDIFF(wk, (select top 1 (cast(his1.dthistory as datetime) + cast(his1.tmhistory as datetime))
   from wfhistory his1
   where his1.idprocess = his.idprocess and his1.idstruct = his.idstruct and his1.DTHISTORY+his1.tmhistory < his.dthistory+his.tmhistory
   and his1.fgtype = 6
   order by his1.dthistory+his1.tmhistory desc), (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime))) * 2)
  -(CASE WHEN DATENAME(dw, (select top 1 (cast(his1.dthistory as datetime) + cast(his1.tmhistory as datetime))
   from wfhistory his1
   where his1.idprocess = his.idprocess and his1.idstruct = his.idstruct and his1.DTHISTORY+his1.tmhistory < his.dthistory+his.tmhistory
   and his1.fgtype = 6
   order by his1.dthistory+his1.tmhistory desc)) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, (cast(his.dthistory as datetime) + cast(his.tmhistory as datetime))) = 'Saturday' THEN 1 ELSE 0 END) as tempo_wd
, 1 AS quantidade
FROM DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join WFHISTORY HIS ON his.idprocess = wf.idobject and HIS.FGTYPE = 9
inner join wfstruct stru on stru.idobject = his.idstruct
WHERE (wf.cdprocessmodel=2808 or wf.cdprocessmodel=2909)
and stru.idstruct = 'Decisão1696121412176'
