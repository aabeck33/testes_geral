select wf.idprocess, wf.nmprocess, wf.dtstart+tmstart as dtstart, wf.dtfinish+tmfinish as dtfinish
--, case wf.fgstatus
--    when 1 then 'Em andamento'
--    when 2 then 'Suspenso'
--    when 3 then 'Cancelado'
--    when 4 then 'Encerrado'
--    when 5 then 'Bloqueado para edição'
--end as procstatus
, case form.UA001
    when 1 then 'Employe'
    when 2 then 'Contractor/Guest'
end as envolved
, (cast(form.UA004 as datetime) + CAST(form.UA005/86400 as datetime)) as dtoccurrence
, case form.ua006
    when 1 then 'Overtime' else 'Worktime' end as wtime
, incloc.ua001 as location, incloc.ua003 as location_owner,  inceqtp.ua001 as eqtype, incfailuremd.ua001 as failuremode, inctype.ua001 as inctype, increleaseloc.ua001 as releaseloc, coalesce(inclevel.ua001, 'N/A') as inclevel
, case wf.fgstatus
	when 1 then 'In Progress'
	when 2then 'Postponed'
	when 3 then 'Cancelled'
	when 4 then 'Closed'
	end as procstatus
, 1 as qt
from DYNua061 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join DYNua065 incloc on incloc.oid = form.OIDABCZ6JVUDN25I7U
inner join DYNua066 inceqtp on inceqtp.oid = form.OIDABCZP0NQD9AM1AI
inner join DYNua067 incfailuremd on incfailuremd.oid = form.OIDABC8FBMPRAZC9GY
inner join DYNua068 inctype on inctype.oid = form.OIDABCEYNGGJ1JHL4W
inner join DYNua069 increleaseloc on increleaseloc.oid = form.OIDABCS6EPH7VXUDWO
left join DYNua070 inclevel on inclevel.oid = form.OIDABC22KVR1WETMCS
where wf.cdprocessmodel = 4884 and wf.fgstatus in (1,4)
