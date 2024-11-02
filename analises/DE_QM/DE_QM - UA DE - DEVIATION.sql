Select wf.idprocess, wf.nmprocess, wf.dtstart, wf.dtfinish
, CASE wf.fgstatus
    WHEN 1 THEN 'In progress'
    WHEN 2 THEN 'Suspended'
    WHEN 3 THEN 'Canceled'
    WHEN 4 THEN 'Closed'
    WHEN 5 THEN 'Locked from editing'
END AS statusproc
, gnrev.NMREVISIONSTATUS as statusExec
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, (SELECT str.dtexecution+str.tmexecution FROM WFSTRUCT STR, WFACTIVITY WFA WHERE str.idprocess = wf.idobject and str.idobject = wfa.idobject and str.idstruct = 'Decisão141027113714228') qaApprov
,  case form.tds052 WHEN 1 THEN 'YES' WHEN 2 THEN 'NO' END AS recurrent
, criticidade.tbs002 as Critic
, area.tbs11 as OccurrenceArea
, desv_cat.tbs006 as Deviation_Category
, root_cat.tbs007 as root_cause
, 1 as Qty
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
LEFT join DYNtbs002 criticidade on form.OIDABC4SFABC3QP = criticidade.oid
LEFT join DYNtbs011 area on form.OIDABCO2WABCQAO = area.oid
LEFT join DYNtbs006 desv_cat on form.OIDABCV3FABC895 = desv_cat.oid
LEFT join DYNtbs007 root_cat on form.OIDABCHG0ABCJLN = root_cat.oid

where wf.cdprocessmodel = 4469
