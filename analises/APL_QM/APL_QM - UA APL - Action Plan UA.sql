select case act.fgstatus
    when 1 then 'Planning'
    when 2 then 'Planning approval'
    when 3 then 'Execution'
    when 4 then 'Effectinveness verification'
    when 5 then 'Finished'
    WHEN 6 THEN 'Cancelled' 
    WHEN 7 THEN 'Cancelled' 
    WHEN 8 THEN 'Cancelled' 
    WHEN 9 THEN 'Cancelled' 
    WHEN 10 THEN 'Cancelled' 
    WHEN 11 THEN 'Cancelled'
end as status
, case actp.fgstatus
    when 1 then 'Planning'
    when 2 then 'Planning approval'
    when 3 then 'Execution'
    when 4 then 'Effectinveness verification'
    when 5 then 'Finished'
    WHEN 6 THEN 'Cancelled' 
    WHEN 7 THEN 'Cancelled' 
    WHEN 8 THEN 'Cancelled' 
    WHEN 9 THEN 'Cancelled' 
    WHEN 10 THEN 'Cancelled' 
    WHEN 11 THEN 'Cancelled'
end as [AP status]
, act.VLPERCENTAGEM as [%]
, actp.idactivity as [AP ID #], actp.nmactivity as [AP Title], act.idactivity as [Task #], act.nmactivity as [Task Title]
, act.dtstartplan as [Start Date]
, act.dtfinishplan as [Due Date]
, act.dtstart as [Start Date real]
, act.dtfinish as [Due Date real]
, actp.dtstartplan as [AP Start Date]
, actp.dtfinishplan as [AP Due Date]
, actp.dtstart as [AP Start Date real]
, actp.dtfinish as [AP Due Date real]
, case when (act.fgstatus = 4 or act.fgstatus = 5) then act.dtfinish else null end as Submitted
, usr.nmuser as [Name], dep.iddepartment +' - '+ dep.nmdepartment as [Department]
, cast(coalesce((select substring((select ' | '+ wf.idprocess +' - '+ format(wf.dtstart, 'MM/dd/yyyy') as [text()] from DYNtds038 form
                                   inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
                                   inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
                                   INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
                                   inner join DYNtds041 rpl on rpl.OIDABCFHVABCAUY = form.oid
                                   where wf.cdprocessmodel = 4473 and form.tds005 = 2 and rpl.tds011 = actp.cdgenactivity and rpl.tds012 = act.cdgenactivity
                                   order by wf.dtstart
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as Requestes --requestList--
, 1 as quant
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactivity act on act.cdactivityowner = actp.cdgenactivity
INNER JOIN gntask gntk ON gntk.cdgenactivity = act.cdgenactivity
LEFT OUTER JOIN aduser usr ON act.cduser = usr.cduser
LEFT OUTER JOIN aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1
LEFT OUTER JOIN addepartment dep on dep.cddepartment = rel.cddepartment
where plano.CDACTIONPLANTYPE in (122, 131, 132, 133, 134, 135)
