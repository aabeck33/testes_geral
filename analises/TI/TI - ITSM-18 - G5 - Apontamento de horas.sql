select (sum(coalesce(horas,0)) / qhm.horasMes) * 100 as indicador, sum(horas) as horas
, qhm.ano as anoap, qhm.mes as mesap, depset.depart, depset.setor, usr.nmuser as analista, qhm.horasMes
FROM aduser usr
left join aduser lider on lider.cduser = usr.cdleader
inner join DYNitsm016 resp on resp.itsm001 = usr.nmuser or resp.itsm001 = lider.nmuser
inner join (select oid, left(itsm001, charindex('_', itsm001) -1) as depart, right(itsm001, len(itsm001) - charindex('_', itsm001)) as setor from DYNitsm020) depset on depset.oid = resp.OIDABCKIK9UXB5HNKT
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.iddepartment like 'ti %'
inner join adposition pos on pos.cdposition = rel.cdposition and pos.nmposition <> 'Diretor' and pos.nmposition <> 'Gerente' and pos.nmposition <> 'Vice presidente'
inner join (select year(getdate()) as ano, num.itsm001 as mes, ((DATEDIFF(DAY, DATEFROMPARTS(YEAR(getdate()),num.itsm001,1), eomonth(datefromparts(year(getdate()),num.itsm001,1)))) - (DATEDIFF(WEEK, DATEFROMPARTS(YEAR(getdate()),num.itsm001,1), eomonth(datefromparts(year(getdate()),num.itsm001,1))) * 2) -
                CASE WHEN DATENAME(WEEKDAY, DATEFROMPARTS(YEAR(getdate()),num.itsm001,1)) = 'Sunday' THEN 1
                    ELSE 0
                END +
                CASE WHEN DATENAME(WEEKDAY, eomonth(datefromparts(year(getdate()),num.itsm001,1))) = 'Saturday' THEN 1
                    ELSE 0
                END) * 8 as horasMes
                from DYNitsm011 num
                where num.itsm001 <= month(getdate())
) qhm on 1 = 1
inner join (
SELECT TIMESHEETVIEW.DTACTUAL, TIMESHEETVIEW.NMRESOURCE, TIMESHEETVIEW.cduser
, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0)) AS QTTOTALMIN
, DATEADD(ms, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0)) % 1000, DATEADD(ss, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0))/1000, CONVERT(DATETIME2(3),'19700101'))) AS QTHORAS
, TIMESHEETVIEW.IDOBJECT AS OBJETO, TIMESHEETVIEW.NMACTIVITY AS ATIVIDADE
, TIMESHEETVIEW.CDISOSYSTEM, GTE.DSDESCRIPTION
, GTS.FGSTATUS
, cast((cast(Datepart(hh,(DATEADD(ms, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0)) % 1000, DATEADD(ss, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0))/1000, CONVERT(DATETIME2(3),'19700101')))))*3600 as float) + cast(Datepart(mi,(DATEADD(ms, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0)) % 1000, DATEADD(ss, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0))/1000, CONVERT(DATETIME2(3),'19700101')))))*60 as float)+ cast(Datepart(ss,(DATEADD(ms, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0)) % 1000, DATEADD(ss, (COALESCE (CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTSTRAIGHTMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=2 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0) + COALESCE(CASE WHEN FGOVER=0 THEN (CAST( TIMESHEETVIEW.QTOVERMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) ELSE CASE WHEN FGOVER=1 THEN (CAST( GTE.QTTOTALMIN AS NUMERIC(28,12)) * CAST( 60 * 1000 AS NUMERIC(28,12))) END END, 0))/1000, CONVERT(DATETIME2(3),'19700101'))))) as float)) / 3600 as float) as horas
FROM (
--Projeto
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, ATITYPE.IDTASKTYPE + ' - ' + ATITYPE.NMTASKTYPE AS IDTYPE, ATI.CDTASKTYPE AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, CASE ATI.FGCHARGE WHEN 1 THEN 1 ELSE 2 END AS CHARGE, ATI.CDTASK AS CDACTIVITY, ATI.NMIDTASK AS IDACTIVITY, ATB.CDTASK AS CDOBJECT, ATB.NMIDTASK AS IDOBJECT, ATB.NMTASK AS NMOBJECT, ATI.FGTASKTYPE AS FGACTIVITYTYPE, ATI.NMTASK AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN PRTASKTIMESHEET TASKTIME ON (TASKTIME.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN PRTASK ATI ON (ATI.CDTASK=TASKTIME.CDTASK)
LEFT OUTER JOIN PRTASKTYPE ATITYPE ON (ATI.CDTASKTYPE=ATITYPE.CDTASKTYPE)
INNER JOIN PRTASK ATB ON (ATI.CDBASETASK=ATB.CDTASK)
	LEFT JOIN (SELECT DISTINCT PVIEW.PR_CDTASK FROM (SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=1
	/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
	SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDPOSITION=ACCVIEW.CDPOSITION  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=2
	/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
	SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT AND UDP.CDPOSITION=ACCVIEW.CDPOSITION  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=3
	/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
	SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, ACCVIEW.CDUSER FROM PRTASKACCESS ACCVIEW  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=4
	/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
	SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, TMM.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADTEAMUSER TMM ON TMM.CDTEAM=ACCVIEW.CDTEAM  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=5
	) PVIEW WHERE 1=1) PRTASKSECURITY ON PRTASKSECURITY.PR_CDTASK=ATB.CDBASETASK AND ATB.FGRESTRICT=1
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
WHERE ATI.FGTASKTYPE=1


UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, NULL AS IDTYPE, 0 AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, GNA.IDACTIVITY AS IDACTIVITY, ASEXECACT.CDEXECACTIVITY AS CDOBJECT, GNA.IDACTIVITY AS IDOBJECT, CASE WHEN ASEXECACT.CDPLANNING IS NULL THEN ASACT.IDACTIVITY + ' - ' + ASACT.NMACTIVITY ELSE ASPLANACT.IDPLANACTIVITY + ' - ' + ASPLANACT.NMPLANACTIVITY END AS NMOBJECT, CAST(8 AS NUMERIC(10)) AS FGACTIVITYTYPE, GNA.IDACTIVITY AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN GNACTIVITYTSHEET GNTS ON (GNTS.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
INNER JOIN GNACTIVITY GNA ON (GNA.CDGENACTIVITY=GNTS.CDGENACTIVITY)
INNER JOIN GNACTIVITYTIMECFG GNCFG ON (GNA.CDACTIVITYTIMECFG=GNCFG.CDACTIVITYTIMECFG)
INNER JOIN ASEXECACTIVITY ASEXECACT ON (GNA.CDGENACTIVITY=ASEXECACT.CDGENACTIVITY)
LEFT JOIN ASPLANACTIVITY ASPLANACT ON (ASPLANACT.CDPLANACTIVITY=ASEXECACT.CDPLANNING)
INNER JOIN ASACTIVITY ASACT ON (ASEXECACT.CDACTIVITY=ASACT.CDACTIVITY)
WHERE ASEXECACT.FGACTTYPE=1


UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, NULL AS IDTYPE, 0 AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, GNA.IDACTIVITY AS IDACTIVITY, ASEXECACT.CDEXECACTIVITY AS CDOBJECT, GNA.IDACTIVITY AS IDOBJECT, CASE WHEN ASEXECACT.CDPLANNING IS NULL THEN ASACT.IDACTIVITY + ' - ' + ASACT.NMACTIVITY ELSE ASPLANACT.IDPLANACTIVITY + ' - ' + ASPLANACT.NMPLANACTIVITY END AS NMOBJECT, CAST(9 AS NUMERIC(10)) AS FGACTIVITYTYPE, GNA.IDACTIVITY AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN GNACTIVITYTSHEET GNTS ON (GNTS.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
INNER JOIN GNACTIVITY GNA ON (GNA.CDGENACTIVITY=GNTS.CDGENACTIVITY)
INNER JOIN GNACTIVITYTIMECFG GNCFG ON (GNA.CDACTIVITYTIMECFG=GNCFG.CDACTIVITYTIMECFG)
INNER JOIN ASEXECACTIVITY ASEXECACT ON (GNA.CDGENACTIVITY=ASEXECACT.CDGENACTIVITY)
LEFT JOIN ASPLANACTIVITY ASPLANACT ON (ASPLANACT.CDPLANACTIVITY=ASEXECACT.CDPLANNING)
INNER JOIN ASACTIVITY ASACT ON (ASEXECACT.CDACTIVITY=ASACT.CDACTIVITY)
WHERE ASEXECACT.FGACTTYPE=3


UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, NULL AS IDTYPE, 0 AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, GNA.IDACTIVITY AS IDACTIVITY, ASEXECACT.CDEXECACTIVITY AS CDOBJECT, GNA.IDACTIVITY AS IDOBJECT, CASE WHEN ASEXECACT.CDPLANNING IS NULL THEN ASACT.IDACTIVITY + ' - ' + ASACT.NMACTIVITY ELSE ASPLANACT.IDPLANACTIVITY + ' - ' + ASPLANACT.NMPLANACTIVITY END AS NMOBJECT, CAST(10 AS NUMERIC(10)) AS FGACTIVITYTYPE, GNA.IDACTIVITY AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN GNACTIVITYTSHEET GNTS ON (GNTS.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
INNER JOIN GNACTIVITY GNA ON (GNA.CDGENACTIVITY=GNTS.CDGENACTIVITY)
INNER JOIN GNACTIVITYTIMECFG GNCFG ON (GNA.CDACTIVITYTIMECFG=GNCFG.CDACTIVITYTIMECFG)
INNER JOIN ASEXECACTIVITY ASEXECACT ON (GNA.CDGENACTIVITY=ASEXECACT.CDGENACTIVITY)
LEFT JOIN ASPLANACTIVITY ASPLANACT ON (ASPLANACT.CDPLANACTIVITY=ASEXECACT.CDPLANNING)
INNER JOIN ASACTIVITY ASACT ON (ASEXECACT.CDACTIVITY=ASACT.CDACTIVITY)
WHERE ASEXECACT.FGACTTYPE IN (2,6,7,8)

--Plano de ação
UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, NULL AS IDTYPE, 0 AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, GNA.IDACTIVITY, CASE WHEN GNACT2.CDGENACTIVITY IS NULL THEN GNA.CDGENACTIVITY ELSE GNACT2.CDGENACTIVITY END AS CDOBJECT, CASE WHEN GNACT2.IDACTIVITY IS NULL THEN GNA.IDACTIVITY ELSE GNACT2.IDACTIVITY END AS IDOBJECT, CASE WHEN GNACT2.NMACTIVITY IS NULL THEN GNA.NMACTIVITY ELSE GNACT2.NMACTIVITY END AS NMOBJECT, CASE WHEN GNA.CDACTIVITYOWNER IS NULL THEN 6 ELSE 7 END AS FGACTIVITYTYPE,GNA.NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN GNACTIVITYTSHEET GNTS ON (GNTS.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
INNER JOIN GNACTIVITY GNA ON (GNA.CDGENACTIVITY=GNTS.CDGENACTIVITY)
INNER JOIN GNTASK GNTK ON (GNA.CDGENACTIVITY=GNTK.CDGENACTIVITY)
LEFT OUTER JOIN GNGENTYPE GNGNTP ON (GNGNTP.CDGENTYPE=GNTK.CDTASKTYPE)
LEFT OUTER JOIN GNACTIVITY GNACT2 ON (GNACT2.CDGENACTIVITY=GNA.CDACTIVITYOWNER)
LEFT OUTER JOIN GNACTIONPLAN GNACTPL ON (GNACTPL.CDGENACTIVITY=GNACT2.CDGENACTIVITY)
LEFT OUTER JOIN GNGENTYPE GNGNTP2 ON (GNGNTP2.CDGENTYPE=GNACTPL.CDACTIONPLANTYPE)
INNER JOIN ADUSER ADUS ON (GNA.CDUSER=ADUS.CDUSER)
WHERE 1 = 1


UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, GNGT.IDGENTYPE + ' - ' + GNGT.NMGENTYPE AS IDTYPE, GNM.CDMEETINGTYPE AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, 2 AS CHARGE, GNM.CDMEETING AS CDACTIVITY, GNM.IDMEETING AS IDACTIVITY, GNM.CDMEETING AS CDOBJECT, GNM.IDMEETING AS IDOBJECT, GNM.NMMEETING AS NMOBJECT, 4 AS FGACTIVITYTYPE, GNM.NMMEETING AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN GNMEETINGTSHEET GMTS ON (GMTS.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN GNMEETING GNM ON (GNM.CDMEETING=GMTS.CDMEETING)
LEFT OUTER JOIN GNGENTYPE GNGT ON (GNM.CDMEETINGTYPE=GNGT.CDGENTYPE)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
WHERE 1 = 1

--Workflow
UNION ALL
SELECT GNTS.CDISOSYSTEM, GNTS.CDTIMESHEET, GNR.IDRESOURCE, GNR.NMRESOURCE, GNR.CDRESOURCE, '' AS IDTYPE, -1 AS TYPEDATA, 0 AS PLANEJADO, GNTS.DTACTUAL, GNTS.CDUSER, GNR.CDUSER AS RESOURCEUSER, GNTS.FGSTATUS, GNTS.QTSTRAIGHTMIN, GNTS.QTOVERMIN, GNTS.TMSTRAIGHTHOURS, GNTS.TMOVERHOURS, GNTS.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, WFS.IDSTRUCT AS IDACTIVITY, GNAWF.CDGENACTIVITY AS CDOBJECT, WFP.IDPROCESS AS IDOBJECT, WFP.NMPROCESS AS NMOBJECT, 11 AS FGACTIVITYTYPE, WFS.NMSTRUCT AS NMACTIVITY, WFP.IDOBJECT AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNACTIVITY GNA
INNER JOIN WFACTIVITY WFA ON (WFA.CDGENACTIVITY=GNA.CDGENACTIVITY)
INNER JOIN WFSTRUCT WFS ON (WFS.IDOBJECT=WFA.IDOBJECT)
INNER JOIN WFPROCESS WFP ON (WFP.IDOBJECT=WFS.IDPROCESS)
INNER JOIN GNACTIVITY GNAWF ON (GNAWF.CDGENACTIVITY=WFP.CDGENACTIVITY)
INNER JOIN GNACTIVITYTSHEET GNATS ON (GNATS.CDGENACTIVITY=GNA.CDGENACTIVITY)
INNER JOIN GNTIMESHEET GNTS ON (GNTS.CDTIMESHEET=GNATS.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=GNTS.CDRESOURCE)
INNER JOIN (SELECT DISTINCT Z.IDOBJECT FROM (SELECT AUXWFP.IDOBJECT FROM WFPROCESS AUXWFP WHERE AUXWFP.FGSTATUS <= 5 AND (AUXWFP.FGMODELWFSECURITY IS NULL OR AUXWFP.FGMODELWFSECURITY=0) UNION ALL SELECT T.IDOBJECT FROM (SELECT MIN(PERM99.FGPERMISSION) AS FGPERMISSION, PERM99.IDOBJECT
FROM (SELECT WFP.IDOBJECT, PERM1.FGPERMISSION FROM (SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, TM.CDUSER AS USERCD
	FROM PMPROCACCESSLIST PP INNER JOIN ADTEAMUSER TM ON PP.CDTEAM=TM.CDTEAM WHERE PP.FGACCESSTYPE=1
UNION ALL
SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE PP.FGACCESSTYPE=2
UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON (PP.CDDEPARTMENT=UDP.CDDEPARTMENT AND PP.CDPOSITION=UDP.CDPOSITION) WHERE PP.FGACCESSTYPE=3
UNION ALL
SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDPOSITION=UDP.CDPOSITION WHERE PP.FGACCESSTYPE=4
UNION ALL
SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, PP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP WHERE PP.FGACCESSTYPE=5
UNION ALL
SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, US.CDUSER AS USERCD FROM PMPROCACCESSLIST PP CROSS JOIN ADUSER US WHERE PP.FGACCESSTYPE=6
UNION ALL
SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERROLE RL ON RL.CDROLE=PP.CDROLE WHERE PP.FGACCESSTYPE=7
) PERM1 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON (PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDPROC=GNASSOC.CDPROC) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PERM1.CDPROC WHERE GNCTRL.CDRELATEDFIELD IN (501) AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL) AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5
UNION ALL
SELECT PERM2.IDOBJECT, PERM2.FGPERMISSION FROM (SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, WFP.CDUSERSTART AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC WHERE PP.FGACCESSTYPE=30
AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5
UNION ALL
SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, US.CDLEADER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE PP.FGACCESSTYPE=31
AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5) PERM2 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON (PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDPROC=GNASSOC.CDPROC) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY WHERE GNCTRL.CDRELATEDFIELD IN (501) AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL)) PERM99
WHERE 1=1 GROUP BY PERM99.IDOBJECT) T WHERE 1 = 1
UNION ALL
SELECT T.IDOBJECT FROM (SELECT PERM.IDOBJECT, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM1.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADTEAMUSER TM ON PM.CDTEAM=TM.CDTEAM WHERE PM.FGACCESSTYPE=1
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE PM.FGACCESSTYPE=2
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT AND PM.CDPOSITION=UDP.CDPOSITION WHERE PM.FGACCESSTYPE=3
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDPOSITION=UDP.CDPOSITION WHERE PM.FGACCESSTYPE=4
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM WHERE PM.FGACCESSTYPE=5
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM CROSS JOIN ADUSER US WHERE PM.FGACCESSTYPE=6
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERROLE RL ON RL.CDROLE=PM.CDROLE WHERE PM.FGACCESSTYPE=7
) PERM1 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM1.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1
UNION ALL
SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM2.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PMA.CDCREATEDBY AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE WHERE PM.FGACCESSTYPE=8
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT WHERE PM.FGACCESSTYPE=9
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON (DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT AND DEP2.CDPOSITION=DEP1.CDPOSITION) WHERE PM.FGACCESSTYPE=10
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDPOSITION=DEP1.CDPOSITION WHERE PM.FGACCESSTYPE=11
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSER US ON US.CDUSER=PMA.CDCREATEDBY WHERE PM.FGACCESSTYPE=12
) PERM2 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM2.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1
UNION ALL
SELECT PERM3.IDOBJECT, PMA.FGUSETYPEACCESS, PERM3.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, WFP.CDUSERSTART AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE PM.FGACCESSTYPE=30
AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1
UNION ALL
SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE PM.FGACCESSTYPE=31
AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1) PERM3 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM3.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM3.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM3.CDACTTYPE=PMA.CDACTTYPE WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND PMA.FGUSETYPEACCESS=1) PERM GROUP BY PERM.IDOBJECT) T WHERE 1 = 1
UNION ALL
SELECT AUXWFP.IDOBJECT FROM WFPROCESS AUXWFP INNER JOIN WFPROCSECURITYLIST WFLIST ON (AUXWFP.IDOBJECT=WFLIST.IDPROCESS) INNER JOIN WFPROCSECURITYCTRL WFCTRL ON (WFLIST.CDACCESSLIST=WFCTRL.CDACCESSLIST AND WFLIST.IDPROCESS=WFCTRL.IDPROCESS) WHERE WFCTRL.CDACCESSROLEFIELD IN (501)
AND WFLIST.FGACCESSTYPE=5 AND WFLIST.FGACCESSEXCEPTION=1
AND AUXWFP.FGSTATUS <= 5) Z) MYPERM ON (WFP.IDOBJECT=MYPERM.IDOBJECT)
WHERE (WFP.CDPRODAUTOMATION IS NULL OR WFP.CDPRODAUTOMATION NOT IN (160, 202, 275))


UNION ALL
SELECT GNTS.CDISOSYSTEM, GNTS.CDTIMESHEET, GNR.IDRESOURCE, GNR.NMRESOURCE, GNR.CDRESOURCE, '' AS IDTYPE, -1 AS TYPEDATA, 0 AS PLANEJADO, GNTS.DTACTUAL, GNTS.CDUSER, GNR.CDUSER AS RESOURCEUSER, GNTS.FGSTATUS, GNTS.QTSTRAIGHTMIN, GNTS.QTOVERMIN, GNTS.TMSTRAIGHTHOURS, GNTS.TMOVERHOURS, GNTS.QTTOTALMIN, 2 AS CHARGE, GNA.CDGENACTIVITY AS CDACTIVITY, TSW.NMPREFIX + '-' + CAST(TST.NRTASK AS VARCHAR(255)) AS IDACTIVITY, TSW.CDWORKSPACE AS CDOBJECT, TSW.NMPREFIX AS IDOBJECT, TSW.NMWORKSPACE AS NMOBJECT, 14 AS FGACTIVITYTYPE, TST.NMTITLE AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, TST.CDTASK
FROM GNACTIVITY GNA
INNER JOIN WFPROCESS WFP ON (WFP.CDGENACTIVITY=GNA.CDGENACTIVITY)
INNER JOIN TSTASK TST ON (TST.IDOBJECT=WFP.IDOBJECT)
INNER JOIN TSWORKSPACE TSW ON (TSW.CDWORKSPACE=TST.CDWORKSPACE)
INNER JOIN TSFLOWSTEP TSFS ON (TSFS.CDFLOW=TST.CDFLOW AND TSFS.CDSTEP=TST.CDSTEP)
LEFT JOIN TSSPRINT TSS ON (TSS.CDSPRINT=TST.CDSPRINT AND TSS.CDWORKSPACE=TST.CDWORKSPACE)
INNER JOIN GNACTIVITYTSHEET GNATS ON (GNATS.CDGENACTIVITY=GNA.CDGENACTIVITY)
INNER JOIN GNTIMESHEET GNTS ON (GNTS.CDTIMESHEET=GNATS.CDTIMESHEET)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=GNTS.CDRESOURCE)
WHERE 1 = 1


UNION ALL
SELECT TIMESHEET.CDISOSYSTEM, TIMESHEET.CDTIMESHEET, GNR.IDRESOURCE AS IDRESOURCE, GNR.NMRESOURCE AS NMRESOURCE, GNR.CDRESOURCE, ATITYPE.IDTASKTYPE + ' - ' + ATITYPE.NMTASKTYPE AS IDTYPE, ATI.CDTASKTYPE AS TYPEDATA, 0 AS PLANEJADO, TIMESHEET.DTACTUAL, TIMESHEET.CDUSER, GNR.CDUSER AS RESOURCEUSER, TIMESHEET.FGSTATUS, TIMESHEET.QTSTRAIGHTMIN, TIMESHEET.QTOVERMIN, TIMESHEET.TMSTRAIGHTHOURS, TIMESHEET.TMOVERHOURS, TIMESHEET.QTTOTALMIN, CASE ATI.FGCHARGE WHEN 1 THEN 1 ELSE 2 END AS CHARGE, ATI.CDTASK AS CDACTIVITY, ATI.NMIDTASK AS IDACTIVITY, ATI.CDTASK AS CDOBJECT, ATI.NMIDTASK AS IDOBJECT, ATI.NMTASK AS NMOBJECT, ATI.FGTASKTYPE AS FGACTIVITYTYPE, ATI.NMTASK AS NMACTIVITY, CAST(NULL AS VARCHAR(50)) AS IDOBJECTPROCESS, CAST(NULL AS NUMERIC(10)) AS CDTASK
FROM GNTIMESHEET TIMESHEET
INNER JOIN PRTASKTIMESHEET TASKTIME ON (TASKTIME.CDTIMESHEET=TIMESHEET.CDTIMESHEET)
INNER JOIN PRTASK ATI ON (ATI.CDTASK=TASKTIME.CDTASK)
LEFT JOIN (SELECT DISTINCT PVIEW.PR_CDTASK FROM (SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=1
/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDPOSITION=ACCVIEW.CDPOSITION  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=2
/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, UDP.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADUSERDEPTPOS UDP ON UDP.CDDEPARTMENT=ACCVIEW.CDDEPARTMENT AND UDP.CDPOSITION=ACCVIEW.CDPOSITION  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=3
/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, ACCVIEW.CDUSER FROM PRTASKACCESS ACCVIEW  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=4
/*DONTREMOVE*/UNION ALL/*DONTREMOVE*/
SELECT ACCVIEW.CDTASK AS PR_CDTASK, ACCVIEW.FGACCESSCOST, TMM.CDUSER FROM PRTASKACCESS ACCVIEW INNER JOIN ADTEAMUSER TMM ON TMM.CDTEAM=ACCVIEW.CDTEAM  WHERE ACCVIEW.FGACCESS=1 AND ACCVIEW.FGTEAMMEMBER=5
) PVIEW WHERE 1=1) PRTASKSECURITY ON PRTASKSECURITY.PR_CDTASK=ATI.CDBASETASK AND ATI.FGRESTRICT=1 LEFT OUTER JOIN PRTASKTYPE ATITYPE ON (ATI.CDTASKTYPE=ATITYPE.CDTASKTYPE)
INNER JOIN GNRESOURCEVIEW GNR ON (GNR.CDRESOURCE=TIMESHEET.CDRESOURCE)
WHERE ATI.FGTASKTYPE IN (2, 3) AND (( ATI.FGRESTRICT=2 OR ATI.FGRESTRICT IS NULL OR ATI.FGRESTRICT=0) OR (PRTASKSECURITY.PR_CDTASK IS NOT NULL))
)TIMESHEETVIEW, GNTIMESHEET GTS, GNTIMEENTRY GTE
WHERE TIMESHEETVIEW.CDTIMESHEET=GTS.CDTIMESHEET AND GTE.CDTIMESHEET=TIMESHEETVIEW.CDTIMESHEET
) timesheetcomp on timesheetcomp.cduser = usr.cduser and year(timesheetcomp.DTACTUAL) = qhm.ano and month(timesheetcomp.DTACTUAL) = qhm.mes
where usr.FGUSERENABLED = 1
and (qhm.ano = datepart(yyyy, getdate()) or qhm.ano = datepart(yyyy, getdate()) - 1)
group by qhm.ano, qhm.mes, depset.depart, depset.setor, usr.nmuser, qhm.horasMes
