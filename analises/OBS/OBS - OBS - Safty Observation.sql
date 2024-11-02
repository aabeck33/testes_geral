SELECT 
    actp.idactivity AS plano,
    actp.nmactivity AS plan_name,
    act.idactivity AS activity,
    act.nmactivity AS activity_name,
    actp.DTINSERT AS action_registration_date
  ,COALESCE(
        (SELECT SUBSTRING(
            (SELECT ' | ' + wf.idprocess AS [text()]
             FROM gnassocactionplan stpl
             INNER JOIN GNACTIVITY GNP ON stpl.cdassoc = GNP.cdassoc
             INNER JOIN wfprocess wf ON wf.CDGENACTIVITY = gnp.CDGENACTIVITY
             WHERE plano.cdgenactivity = stpl.cdactionplan
             FOR XML PATH('')), 4, 4000)
        ), '') AS listAssociatedProcess,
    CASE act.fgstatus
       WHEN 1 THEN 'Planning'
        WHEN 2 THEN 'Planning Approval'
        WHEN 3 THEN 'Execution'
        WHEN 4 THEN 'Effectiveness Verification / Execution Approval'
        WHEN 5 THEN 'Closed'
        WHEN 6 THEN 'Cancelled'
        WHEN 7 THEN 'Cancelled'
        WHEN 8 THEN 'Cancelled'
        WHEN 9 THEN 'Cancelled'
        WHEN 10 THEN 'Cancelled'
        WHEN 11 THEN 'Cancelled'
	END AS status,
    usr.nmuser AS executor,
    dep.iddepartment,
    acttype.idgentype,
    acttype.nmgentype,
    priori.nmevalresult AS Priority,
    act.dtstartplan,
    act.dtfinishplan,
    act.dtstart,
    act.dtfinish,
    act.dsdescription AS what,
    gntk.dswhy AS why,
    act.dsactivity AS how,
    aprov.dtapprov,
    CASE
        WHEN aprov.fgapprov = 1 THEN 'Approved'
        WHEN aprov.fgapprov = 2 THEN 'Rejected'
    END AS aprovacao,
    aprov.dsobs AS dsobsaprov,
    (SELECT nmuser FROM aduser WHERE cduser = aprov.cduserapprov) AS aprovador
FROM GNACTIONPLAN plano
INNER JOIN gnactivity actp ON actp.CDGENACTIVITY = plano.CDGENACTIVITY AND actp.cdactivityowner IS NULL
INNER JOIN gnactivity act ON act.cdactivityowner = actp.cdgenactivity
INNER JOIN gntask gntk ON gntk.cdgenactivity = act.cdgenactivity
INNER JOIN GNEVALRESULTUSED GNEVALRESACT ON GNEVALRESACT.CDEVALRESULTUSED = actp.CDEVALRSLTPRIORITY
INNER JOIN GNEVALRESULT priori ON priori.CDEVALRESULT = GNEVALRESACT.CDEVALRESULT
INNER JOIN gngentype acttype ON acttype.cdgentype = gntk.cdtasktype
LEFT JOIN aduser usr ON act.cduser = usr.cduser
LEFT JOIN aduserdeptpos rel ON rel.cduser = usr.cduser AND fgdefaultdeptpos = 1
LEFT JOIN addepartment dep ON dep.cddepartment = rel.cddepartment
INNER JOIN gnvwapprovresp aprov ON aprov.cdapprov = act.cdexecroute AND cdprod = 174
    AND ((aprov.fgpend = 2 AND aprov.fgapprov = 1) OR (aprov.fgpend = 1) OR (fgpend IS NULL AND fgapprov IS NULL))
INNER JOIN (
    SELECT MAX(cdcycle) AS maxcycle, cdapprov
    FROM gnvwapprovresp
    WHERE cdprod = 174
    GROUP BY cdapprov
) max_cycle ON aprov.cdcycle = max_cycle.maxcycle
WHERE aprov.cdapprov = max_cycle.cdapprov AND plano.CDACTIONPLANTYPE in (172,168)
