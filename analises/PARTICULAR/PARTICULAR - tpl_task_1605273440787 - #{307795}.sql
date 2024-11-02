select
        tsk.NMTITLE tasktitle,
        tsk.CDTASK,
        CONCAT(wskp.NMPREFIX, CONCAT('-', tsk.NRTASK)) IDTASK,
	spr.nmtitle,
	spr.cdsprint,
	coalesce(sprhist.vlestimatestart, 0) vlestimatestart,
	coalesce(sprhist.vlestimatefinsh, 0) vlestimatefinsh,
	spr.BNSTART,
	spr.BNFINISH,
	spr.FGSTATUS,
        CASE spr.FGSTATUS
		WHEN 1 THEN '#{100470}'
		WHEN 2 THEN '#{303828}'
		WHEN 3 THEN '#{101237}'
	END AS NMSTATUS,
	wskp.CDWORKSPACE,
        CASE wskp.FGENABLED
		WHEN 1 THEN '#{105498}'
		WHEN 2 THEN '#{104499}'
	END AS NMENABLED,
	wskp.NMWORKSPACE,
	wskp.FGENABLED,
	prio.CDPRIORITY,
	prio.NMPRIORITY,
	stp.CDSTEP,
	stp.NMSTEP,
        tsk.CDCREATEDBY,
	creator.nmuser nmcreatedby,
        tsk.CDREPORTER,
	reporter.nmuser nmreporter,
        tsk.CDASSIGNEE,
	assignee.nmuser nmassignee,
	tsktp.CDTASKTYPE,
	tsktp.NMTASKTYPE
from tssprint spr
inner join tssprinthistory sprhist on sprhist.cdsprint = spr.cdsprint
inner join tstask tsk on sprhist.CDTASK = tsk.CDTASK
inner join TSWORKSPACE wskp on wskp.CDWORKSPACE = spr.CDWORKSPACE
inner join TSTASKTYPE tsktp on tsk.CDTASKTYPE = tsktp.CDTASKTYPE
inner join aduser creator on creator.cduser = tsk.CDCREATEDBY
inner join aduser reporter on reporter.cduser = tsk.CDREPORTER
left join aduser assignee on assignee.cduser = tsk.CDASSIGNEE
inner join tsflow flow on flow.CDFLOW = tsk.CDFLOW
inner join TSPRIORITY prio on prio.CDPRIORITY = tsk.CDPRIORITY
inner join tsstep stp on stp.CDSTEP = tsk.CDSTEP
