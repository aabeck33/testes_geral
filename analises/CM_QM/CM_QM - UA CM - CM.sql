Select wf.idprocess, wf.nmprocess, wf.dtstart, wf.dtfinish
, CASE wf.fgstatus
    WHEN 1 THEN 'In progress'
    WHEN 2 THEN 'Suspended'
    WHEN 3 THEN 'Canceled'
    WHEN 4 THEN 'Closed'
    WHEN 5 THEN 'Locked from editing'
END AS statusproc
, gnrev.NMREVISIONSTATUS as statusExec
, CASE form.TDS016
    WHEN 1 THEN 'Critical CM'
    WHEN 2 THEN 'Non-Critical CM'
END AS CRITICI
, cast(coalesce((select substring((select ' | '+ gnactp.idactivity as [text()] from gnactivity gnact
                 left join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
                 left JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
                 left JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
                 where wf.CDGENACTIVITY = gnact.CDGENACTIVITY
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaplacao --listaplação--
, (SELECT str.dtexecution+str.tmexecution FROM WFSTRUCT STR, WFACTIVITY WFA WHERE str.idprocess = wf.idobject and str.idobject = wfa.idobject and str.idstruct = 'Decisão14102914536874') qaApprov
, usr.nmuser as Owner
, case form.tds106 when 0 then 'No' when 1 then 'Yes' end as regulatoryImpact
, (select impact.TDS004 from DYNtds043 impact where impact.OIDABC8EEABCZHC = form.oid and impact.OIDABCVHKABC73U = '4749662ce816f492006c8a9fada7d746') as AnnualRepComm
, 1 as Qty
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join aduser usr on usr.cduser = wf.cduserstart
where wf.cdprocessmodel = 4468
