Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, wf.dtstart as dtabertura, wf.dtfinish as dtfechamento
, (row_number() over (PARTITION BY wf.idprocess,str.nmstruct order by wf.idprocess,str.nmstruct,his.dthistory + his.tmhistory)) as ciclo
, str.nmstruct as atividade
, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
) as atvHabilitada
, his.dthistory + his.tmhistory as atvExecutada
, HIS.NMUSER as atvExecutor
, his.nmaction as atvAcao
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and (str.idstruct = 'Atividade141029141729547' or str.idstruct = 'Atividade14102914459502')
where cdprocessmodel=3234
