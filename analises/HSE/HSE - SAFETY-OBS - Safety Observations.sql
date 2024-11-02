select wf.idprocess, wf.nmprocess, wf.dtstart+tmstart as dtstart, wf.dtfinish+tmfinish as dtfinish
, case wf.fgstatus
    when 1 then 'In progress'
    when 2 then 'Postponed'
    when 3 then 'Cancelled'
    when 4 then 'Finished'
    when 5 then 'Blocked for editing'
end as procstatus
, obstype.ua001 as type, obstopic.ua001 as topic, obsloc.ua001 as location, coalesce(obsstatus.ua001, 'N/A') as finalstatus
, case form.ua002
    when 1 then 'Yes'
    when 2 then 'No'
end as resolved_by_observer
, case wf.fgstatus
    when 4 then wf.dtfinish+tmfinish
    else wf.dtstart+tmstart
end as dtinprogress
, case wf.fgstatus
    when 1 then 1
    else 0
end as qtinprogress
, case wf.fgstatus
    when 4 then 1
    else 0
end as qtclosed
, 1 as qt
from DYNua060 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join DYNua062 obstype on obstype.oid = form.OIDABCPDUHLYO05TNO
left join DYNua063 obsstatus on obsstatus.oid = form.OIDABCIEG083GK2BL2
inner join DYNua064 obstopic on obstopic.oid = form.OIDABC5DPJ5UZQEJ7Z
inner join DYNua065 obsloc on obsloc.oid = form.OIDABCH7ETPYIH2KXZ
where wf.cdprocessmodel = 4872 and wf.fgstatus in (1,4)
