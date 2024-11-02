Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, CASE wf.fgstatus WHEN 1 THEN 'In progress' WHEN 2 THEN 'Suspended' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'Finished' WHEN 5 THEN 'Blocked for edition' END AS statusproc
, wf.dtstart as dtabertura
, CASE wf.fgstatus when 3 then (select top 1 his1.dthistory + his1.tmhistory
                                from wfhistory his1
                                inner join wfprocess wf1 on his1.idprocess = wf1.idobject and wf1.idprocess = wf.idprocess
                                where HIS1.FGTYPE = 3
                                order by his1.dthistory + his1.tmhistory desc
) else wf.dtfinish end as dtfechamento
, (row_number() over (PARTITION BY wf.idprocess,str.nmstruct order by wf.idprocess,str.nmstruct,his.dthistory + his.tmhistory)) as ciclo
, str.nmstruct as atividade
, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
) as atvHabilitada
, his.dthistory + his.tmhistory as atvExecutada
, datediff(DD, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
), (his.dthistory + his.tmhistory)) as atvLeadTime
, dateadd(mi, wfa.qthours, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
)) as atvDueDate
, case when datediff(DD, dateadd(mi, wfa.qthours, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
)), (his.dthistory + his.tmhistory)) <= 0 then 'On Time' else 'Delayed' end as atvLeadTimeStatus
, his.NMUSER as atvExecutor
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
LEFT join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9
LEFT JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and (str.idstruct in ('Decisão141111113212628','Decisão14102914536874','Atividade14102914347264', 'Atividade141029141729547', 'Atividade14102914355828','Atividade1518102355189', 'Atividade14102914355828', 'Atividade1518102355189'))
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
where cdprocessmodel=4468
