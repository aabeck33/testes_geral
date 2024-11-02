update database set txdata = 'select case act.fgstatus
    when 1 then ' + chr(39) + 'Planning' + chr(39) + '
    when 2 then ' + chr(39) + 'Planning approval' + chr(39) + '
    when 3 then ' + chr(39) + 'Execution' + chr(39) + '
    when 4 then ' + chr(39) + 'Effectinveness verification' + chr(39) + '
    when 5 then ' + chr(39) + 'Finished' + chr(39) + '
    WHEN 6 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 7 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 8 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 9 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 10 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 11 THEN ' + chr(39) + 'Cancelled' + chr(39) + '
end as status
, case actp.fgstatus
    when 1 then ' + chr(39) + 'Planning' + chr(39) + '
    when 2 then ' + chr(39) + 'Planning approval' + chr(39) + '
    when 3 then ' + chr(39) + 'Execution' + chr(39) + '
    when 4 then ' + chr(39) + 'Effectinveness verification' + chr(39) + '
    when 5 then ' + chr(39) + 'Finished' + chr(39) + '
    WHEN 6 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 7 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 8 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 9 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 10 THEN ' + chr(39) + 'Cancelled' + chr(39) + ' 
    WHEN 11 THEN ' + chr(39) + 'Cancelled' + chr(39) + '
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
, usr.nmuser as [Name], dep.iddepartment +' + chr(39) + ' - ' + chr(39) + '+ dep.nmdepartment as [Department]
, cast(coalesce((select substring((select ' + chr(39) + ' | ' + chr(39) + '+ wf.idprocess +' + chr(39) + ' - ' + chr(39) + '+ format(wf.dtstart, ' + chr(39) + 'MM/dd/yyyy' + chr(39) + ') as [text()] from DYNtds038 form
                                   inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
                                   inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
                                   INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
                                   inner join DYNtds041 rpl on rpl.OIDABCFHVABCAUY = form.oid
                                   where wf.cdprocessmodel = 4473 and form.tds005 = 2 and rpl.tds011 = actp.cdgenactivity and rpl.tds012 = act.cdgenactivity
                                   order by wf.dtstart
       FOR XML PATH(' + chr(39) + '' + chr(39) + ')), 4, 4000)), ' + chr(39) + 'NA' + chr(39) + ') as varchar(4000)) as Requestes --requestList--
, 1 as quant
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactivity act on act.cdactivityowner = actp.cdgenactivity
INNER JOIN gntask gntk ON gntk.cdgenactivity = act.cdgenactivity
LEFT OUTER JOIN aduser usr ON act.cduser = usr.cduser
LEFT OUTER JOIN aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1
LEFT OUTER JOIN addepartment dep on dep.cddepartment = rel.cddepartment
where plano.CDACTIONPLANTYPE in (122, 131, 132, 133, 134, 135)
' where idanalysis = 'UA APL'