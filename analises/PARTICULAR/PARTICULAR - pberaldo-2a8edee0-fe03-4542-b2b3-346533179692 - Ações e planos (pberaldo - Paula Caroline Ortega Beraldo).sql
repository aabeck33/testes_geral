SELECT CASE WHEN GNACT.FGSTATUS=1 OR GNACT.FGSTATUS=2 THEN CASE WHEN (TMCPLAN.FGIMMEDIATEACTION=2 OR TMCPLAN.FGIMMEDIATEACTION IS NULL) THEN CASE WHEN (GNACT.DTSTARTPLAN IS NOT NULL AND GNACT.DTSTARTPLAN < <!%TODAY%>)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND GNACT.DTSTARTPLAN=<!%TODAY%> AND GNACT.QTTIMESTARTPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10))) THEN '#{100899}' WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTSTARTPLAN >= <!%TODAY%>) THEN '#{100900}' END ELSE '#{100900}' END WHEN GNACT.FGSTATUS=3 OR GNACT.FGSTATUS=13 THEN CASE WHEN (GNACT.DTSTART IS NULL AND ((SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=102)=2)) THEN CASE WHEN (GNACT.DTSTARTPLAN < <!%TODAY%>)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTSTARTPLAN=<!%TODAY%>) AND (GNACT.QTTIMESTARTPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10)))) THEN '#{100899}' WHEN (GNACT.DTSTARTPLAN > dbo.SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>, 6, (CASE WHEN GNACT2.CDGENACTIVITY IS NOT NULL THEN GNACT2.CDCALENDAR ELSE GNACT.CDCALENDAR END))) THEN '#{100900}' ELSE '#{201639}' END WHEN (GNACT.DTSTART IS NOT NULL AND GNACT.DTFINISH IS NULL AND ((SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=102)=2)) THEN CASE WHEN (GNACT.DTFINISHPLAN < <!%TODAY%>)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTSTARTPLAN=<!%TODAY%>) AND (GNACT.QTTIMESTARTPLAN < GNACT.QTTIMESTART)) THEN '#{100899}' WHEN (GNACT.DTFINISHPLAN > dbo.SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>, 6, (CASE WHEN GNACT2.CDGENACTIVITY IS NOT NULL THEN GNACT2.CDCALENDAR ELSE GNACT.CDCALENDAR END))) THEN '#{100900}' ELSE '#{201639}' END WHEN (GNACT.DTSTART IS NOT NULL AND GNACT.DTFINISH IS NOT NULL AND ((SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=102)=2)) THEN CASE WHEN (GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN '#{100900}' WHEN (GNACT.DTFINISH > GNACT.DTFINISHPLAN)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTFINISHPLAN=GNACT.DTFINISH) AND (GNACT.QTTIMEFINISHPLAN < GNACT.QTTIMEFINISH)) THEN '#{100899}' END WHEN (GNACT.DTFINISH IS NOT NULL AND ((SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=102)=1)) THEN CASE WHEN (GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN '#{100900}' WHEN (GNACT.DTFINISH > GNACT.DTFINISHPLAN)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTFINISHPLAN=GNACT.DTFINISH) AND (GNACT.QTTIMEFINISHPLAN < GNACT.QTTIMEFINISH)) THEN '#{100899}' END WHEN (GNACT.DTFINISH IS NULL AND ((SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=102)=1)) THEN CASE WHEN (GNACT.DTFINISHPLAN < <!%TODAY%>)OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTFINISHPLAN=<!%TODAY%>) AND (GNACT.QTTIMEFINISHPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10)))) THEN '#{100899}' WHEN (GNACT.DTFINISHPLAN > dbo.SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>, 6, (CASE WHEN GNACT2.CDGENACTIVITY IS NOT NULL THEN GNACT2.CDCALENDAR ELSE GNACT.CDCALENDAR END))) THEN '#{100900}' ELSE '#{201639}' END END WHEN GNACT.FGSTATUS=5 OR GNACT.FGSTATUS=4 THEN CASE WHEN (GNACT.DTFINISHPLAN < GNACT.DTFINISH) OR (EXISTS (SELECT VLPARAM FROM ADPARAMS WHERE CDISOSYSTEM=174 AND CDPARAM=203 AND VLPARAM=1) AND (GNACT.DTFINISHPLAN=GNACT.DTFINISH) AND (GNACT.QTTIMEFINISHPLAN < GNACT.QTTIMEFINISH)) THEN '#{100899}' WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN '#{100900}' ELSE '#{100899}' END END AS NMDEADLINE,  CASE WHEN GNACT.FGSTATUS=1 THEN '#{100470}' WHEN GNACT.FGSTATUS=2 THEN '#{200135}' WHEN GNACT.FGSTATUS=3 THEN '#{200002}' WHEN GNACT.FGSTATUS=4 AND GNACT.CDACTIVITYOWNER IS NOT NULL THEN '#{218317}' WHEN GNACT.FGSTATUS=4 AND GNACT.CDACTIVITYOWNER IS NULL THEN '#{100476}' WHEN GNACT.FGSTATUS=5 THEN '#{101237}' WHEN GNACT.FGSTATUS=6 THEN '#{104230}' END AS NMACTSTATUS,  CASE WHEN GNACT2.FGSTATUS=1 THEN '#{100470}' WHEN GNACT2.FGSTATUS=2 THEN '#{200135}' WHEN GNACT2.FGSTATUS=3 THEN '#{200002}' WHEN GNACT2.FGSTATUS=4 AND GNACT2.CDACTIVITYOWNER IS NOT NULL THEN '#{218317}' WHEN GNACT2.FGSTATUS=4 AND GNACT2.CDACTIVITYOWNER IS NULL THEN '#{100476}' WHEN GNACT2.FGSTATUS=5 THEN '#{101237}' WHEN GNACT2.FGSTATUS=6 THEN '#{104230}' END AS NMACTIONPLANSTATUS, GNACT.CDGENACTIVITY, GNACT.DTSTARTPLAN, GNACT.DTSTART, GNACT.DTFINISHPLAN, GNACT.DTFINISH, GNACT.VLPERCENTAGEM, GNCOST.MNCOSTPROG, GNCOST.MNCOSTREAL, GNACT2.IDACTIVITY AS IDACTIONPLAN, GNACT2.NMACTIVITY AS NMACTIONPLAN, GNACT.IDACTIVITY, GNACT.NMACTIVITY, GNGNTP.IDGENTYPE, GNGNTP.NMGENTYPE, ADUSR.IDUSER AS IDTASKRESP, CASE WHEN GNACT.CDUSER IS NULL THEN ADEXTUSR.NMUSER ELSE ADUSR.NMUSER END AS NMTASKRESP, ADUSRESPACTION3.NMUSER AS NMACTIONPLANRESP, GNRESUACT.NMEVALRESULT AS NMEVALRESULTACT, (CASE WHEN (ATEAM.IDTEAM IS NOT NULL) THEN ATEAM.IDTEAM + ' - ' + ATEAM.NMTEAM ELSE CAST(NULL AS VARCHAR(255)) END) AS IDNMTEAM, CASE WHEN (AD.IDDEPARTMENT IS NOT NULL) THEN AD.IDDEPARTMENT + ' - ' + AD.NMDEPARTMENT ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMDEPTUSERRESP, CASE WHEN (AP.IDPOSITION IS NOT NULL) THEN AP.IDPOSITION + ' - ' + AP.NMPOSITION ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMPOSUSERRESP, GNT.CDCYCLEPLAN, CASE WHEN GNAPR.FGAPPROV=1 THEN '#{100558}' WHEN GNAPR.FGAPPROV=2 THEN '#{100761}' ELSE NULL END AS FGAPPROV, 1 AS QTD, CASE WHEN GNAPRACT.FGAPPROV=1 THEN '#{100558}' WHEN (GNAPRACT.FGAPPROV IS NULL AND GNAPPEXECACTION.NRLASTCYCLE > 1) THEN '#{100761}' ELSE NULL END AS FGAPPROVACTOPM, GNAPPEXECACTION.NRLASTCYCLE AS CDCYCLEACTION FROM (SELECT CDGENACTIVITY, CDTASK, 2 AS FGPLAN, NULL AS CDACTIONPLAN, CDTASKTYPE AS CDACTIONPLANTYPE, CDISOSYSTEM, FGOBJECT, 2 AS FGMODEL, NULL AS CDFAVORITE, FGIMMEDIATEACTION FROM GNTASK) TMCPLAN INNER JOIN GNACTIVITY GNACT ON (GNACT.CDGENACTIVITY=TMCPLAN.CDGENACTIVITY AND GNACT.CDISOSYSTEM=174) LEFT OUTER JOIN ADUSER ADUSR ON (ADUSR.CDUSER=GNACT.CDUSER) LEFT OUTER JOIN ADUSER ADUSR2 ON (ADUSR2.CDUSER=GNACT.CDUSERACTIVRESP) LEFT OUTER JOIN GNGENTYPE GNGNTP ON (GNGNTP.CDGENTYPE=TMCPLAN.CDACTIONPLANTYPE) LEFT OUTER JOIN GNCOSTCONFIG GNCOST ON (GNACT.CDCOSTCONFIG=GNCOST.CDCOSTCONFIG) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRESACT ON (GNEVALRESACT.CDEVALRESULTUSED=GNACT.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESUACT ON (GNRESUACT.CDEVALRESULT=GNEVALRESACT.CDEVALRESULT) LEFT OUTER JOIN GNACTIVITY GNACT2 ON (GNACT2.CDGENACTIVITY=GNACT.CDACTIVITYOWNER AND GNACT2.CDISOSYSTEM=174) LEFT OUTER JOIN GNACTIONPLAN GNACTPL ON (GNACTPL.CDGENACTIVITY=GNACT2.CDGENACTIVITY) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRES ON (GNEVALRES.CDEVALRESULTUSED=GNACT2.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESU ON (GNRESU.CDEVALRESULT=GNEVALRES.CDEVALRESULT) LEFT OUTER JOIN ADTEAM ATEAM ON (ATEAM.CDTEAM=GNACT.CDTEAM) LEFT OUTER JOIN (SELECT CDASSOC, COUNT(1) AS QTD FROM GNASSOCATTACH GROUP BY CDASSOC) ATTACHASSOC ON ATTACHASSOC.CDASSOC=GNACT.CDASSOC LEFT OUTER JOIN (SELECT CDASSOC, COUNT(1) AS QTD FROM GNASSOCDOCUMENT GROUP BY CDASSOC) DOCASSOC ON DOCASSOC.CDASSOC=GNACT.CDASSOC LEFT OUTER JOIN ADUSER ADUSRESPACTION3 ON (ADUSRESPACTION3.CDUSER=GNACT2.CDUSERACTIVRESP) LEFT OUTER JOIN GNTASK GNT ON (GNT.CDGENACTIVITY=GNACT.CDGENACTIVITY AND GNT.CDCYCLEPLAN IS NOT NULL) LEFT OUTER JOIN ADUSERDEPTPOS ADUD ON (ADUD.CDUSER=ADUSR.CDUSER AND ADUD.FGDEFAULTDEPTPOS=1) LEFT OUTER JOIN ADDEPARTMENT AD ON (AD.CDDEPARTMENT=ADUD.CDDEPARTMENT) LEFT OUTER JOIN ADPOSITION AP ON (AP.CDPOSITION=ADUD.CDPOSITION) LEFT OUTER JOIN GNAPPROV GNAPPEXECACTION ON (GNAPPEXECACTION.CDPROD=GNACT.CDPRODROUTE AND GNACT.CDEXECROUTE=GNAPPEXECACTION.CDAPPROV) LEFT OUTER JOIN (SELECT GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD, MAX(GNAPPROVRESP.FGAPPROV) AS FGAPPROV FROM GNAPPROVRESP INNER JOIN GNACTIVITY ON (GNACTIVITY.CDEXECROUTE=GNAPPROVRESP.CDAPPROV AND GNACTIVITY.CDPRODROUTE=GNAPPROVRESP.CDPROD) INNER JOIN GNACTIONPLAN ON (GNACTIONPLAN.CDGENACTIVITY=GNACTIVITY.CDGENACTIVITY) GROUP BY GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD) GNAPR ON (GNACT2.CDEXECROUTE=GNAPR.CDAPPROV AND GNACT2.CDPRODROUTE=GNAPR.CDPROD AND GNAPR.CDCYCLE=GNT.CDCYCLEPLAN) LEFT OUTER JOIN (SELECT GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD, MAX(GNAPPROVRESP.FGAPPROV) AS FGAPPROV FROM GNAPPROVRESP INNER JOIN GNACTIVITY ON GNACTIVITY.CDEXECROUTE=GNAPPROVRESP.CDAPPROV AND GNACTIVITY.CDPRODROUTE=GNAPPROVRESP.CDPROD INNER JOIN GNTASK ON GNTASK.CDGENACTIVITY=GNACTIVITY.CDGENACTIVITY GROUP BY GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD) GNAPRACT ON GNAPRACT.CDAPPROV=GNACT.CDEXECROUTE AND GNAPRACT.CDPROD=GNACT.CDPRODROUTE AND GNAPRACT.CDCYCLE=GNAPPEXECACTION.NRLASTCYCLE LEFT OUTER JOIN ADEXTERNALUSER ADEXTUSR ON GNACT.CDEXTERNALUSER=ADEXTUSR.CDEXTERNALUSER WHERE 1=1 AND (GNACT.CDACTIVITYOWNER IS NULL OR (GNACT.CDACTIVITYOWNER IS NOT NULL AND GNACTPL.FGMODEL=2 AND EXISTS (SELECT 1 FROM ADMINISTRATION WHERE COALESCE(GNACTPL.FGOBJECT,-1) <> 9 /*sub*/UNION/*sub*/ ALL SELECT 1 FROM ADMINISTRATION WHERE GNACTPL.FGOBJECT=9 AND  (NOT EXISTS (SELECT 1 FROM GNASSOCACTIONPLAN GNACPLAPDI WHERE GNACPLAPDI.CDACTIONPLAN=GNACTPL.CDGENACTIVITY) OR EXISTS (SELECT 1 FROM GNACTIVITY GNACTPDI INNER JOIN GNASSOCACTIONPLAN GNACPLAPDI ON ( GNACPLAPDI.CDACTIONPLAN=GNACTPDI.CDGENACTIVITY) INNER JOIN TRHISTORICAL HIPDI ON ( GNACPLAPDI.CDASSOC=HIPDI.CDASSOC) LEFT OUTER JOIN (/* Pares */ SELECT ADU1.CDUSER, CAST(1072 AS NUMERIC(10)) AS CDUSERDATA FROM ADUSER ADU1 INNER JOIN ADUSER ADU2 ON (ADU2.CDUSER <> ADU1.CDUSER) INNER JOIN ADPARAMS ADP0 ON (ADP0.CDPARAM=3  AND ADP0.CDISOSYSTEM=153  AND ADP0.VLPARAM=1) INNER JOIN ADPARAMS ADP1 ON (ADP1.CDPARAM=20  AND ADP1.CDISOSYSTEM=153) INNER JOIN ADPARAMS ADP2 ON (ADP2.CDPARAM=21  AND ADP2.CDISOSYSTEM=153) INNER JOIN ADPARAMS ADP3 ON (ADP3.CDPARAM=22  AND ADP3.CDISOSYSTEM=153) WHERE 1=1 AND EXISTS ( SELECT 1  FROM ADMINISTRATION  WHERE ADU2.CDLEADER=ADU1.CDLEADER  AND ADP1.VLPARAM=1  AND (ADP2.VLPARAM <> 1 OR ADP3.VLPARAM=2) /*sub*/UNION/*sub*/ ALL SELECT 1  FROM ADUSERDEPTPOS ADUDP1 INNER JOIN ADUSERDEPTPOS ADUDP2 ON ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  WHERE ADUDP1.CDUSER=ADU1.CDUSER  AND ADUDP2.CDUSER=ADU2.CDUSER  AND ADP2.VLPARAM=1  AND (ADP1.VLPARAM <> 1 OR ADP3.VLPARAM=2) /*sub*/UNION/*sub*/ ALL SELECT 1  FROM ADUSERDEPTPOS ADUDP1 INNER JOIN ADUSERDEPTPOS ADUDP2 ON ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  WHERE ADUDP1.CDUSER=ADU1.CDUSER  AND ADUDP2.CDUSER=ADU2.CDUSER  AND ADU2.CDLEADER=ADU1.CDLEADER  AND ADP1.VLPARAM=1  AND ADP2.VLPARAM=1  AND ADP3.VLPARAM=1) AND ADU2.CDUSER=7445 GROUP BY ADU1.CDUSER /*sub*/UNION/*sub*/ /* Lider */ SELECT ADL.CDLEADER AS CDUSER, CAST(1072 AS NUMERIC(10)) AS CDUSERDATA FROM ADUSER ADL INNER JOIN ADPARAMS ADP ON (ADP.CDPARAM=4  AND ADP.CDISOSYSTEM=153  AND ADP.VLPARAM=1) WHERE ADL.CDLEADER IS NOT NULL AND ADL.CDUSER=7445 GROUP BY ADL.CDLEADER /*sub*/UNION/*sub*/ /* Liderados */ SELECT T.CDUSER, CAST(1072 AS NUMERIC(10)) AS CDUSERDATA FROM (SELECT ADU1.CDUSER, ADU0.CDUSER AS CDLEADER, 1 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) WHERE ADU0.CDUSER=7445 /*sub*/UNION/*sub*/ SELECT ADU2.CDUSER, ADU0.CDUSER AS CDLEADER, 2 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) WHERE ADU0.CDUSER=7445 /*sub*/UNION/*sub*/ SELECT ADU3.CDUSER, ADU0.CDUSER AS CDLEADER, 3 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) WHERE ADU0.CDUSER=7445 /*sub*/UNION/*sub*/ SELECT ADU4.CDUSER, ADU0.CDUSER AS CDLEADER, 4 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) WHERE ADU0.CDUSER=7445 /*sub*/UNION/*sub*/ SELECT ADU5.CDUSER, ADU0.CDUSER AS CDLEADER, 5 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) INNER JOIN ADUSER ADU5 ON (ADU5.CDLEADER=ADU4.CDUSER) WHERE ADU0.CDUSER=7445) T INNER JOIN ADPARAMS ADP ON (ADP.CDPARAM=2  AND ADP.CDISOSYSTEM=153  AND ADP.VLPARAM=1) GROUP BY T.CDUSER /*sub*/UNION/*sub*/ /* Proprio usuario */ SELECT CAST(1072 AS NUMERIC(10)) AS CDUSER, CAST(1072 AS NUMERIC(10)) AS CDUSERDATA FROM ADMINISTRATION /*sub*/UNION/*sub*/ /* Equipe de controle por unidade organizacional */ SELECT ADUDPPOS.CDUSER, CAST(1072 AS NUMERIC(10)) AS CDUSERDATA FROM ADDEPARTMENT ADP INNER JOIN ADDEPTSUBLEVEL ADDPSUB ON (ADDPSUB.CDOWNER=ADP.CDDEPARTMENT) INNER JOIN ADUSERDEPTPOS ADUDPPOS ON (ADUDPPOS.CDDEPARTMENT=ADDPSUB.CDDEPT) INNER JOIN ADTEAMUSER ADTU ON (ADTU.CDTEAM=ADP.CDSECURITYTEAM) WHERE ADTU.CDUSER=7445 GROUP BY ADUDPPOS.CDUSER) USERPERM ON (USERPERM.CDUSER=HIPDI.CDUSER AND USERPERM.CDUSERDATA=1072) WHERE GNACTPDI.CDGENACTIVITY=GNACTPL.CDGENACTIVITY AND (EXISTS (SELECT ADT1.CDUSER FROM ADTEAMUSER ADT1  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=1 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=ADT1.CDTEAM) WHERE ADT1.CDUSER=7445)  OR USERPERM.CDUSER IS NOT NULL)))))) AND (((TMCPLAN.CDACTIONPLANTYPE IN(<!%FUNC(com.softexpert.generic.parameter.InClauseBuilder, R05HRU5UWVBF, Q0RHRU5UWVBF, Q0RHRU5UWVBFT1dORVI=,, MjI=,)%>))) OR ((GNACTPL.CDACTIONPLANTYPE IN(<!%FUNC(com.softexpert.generic.parameter.InClauseBuilder, R05HRU5UWVBF, Q0RHRU5UWVBF, Q0RHRU5UWVBFT1dORVI=,, MjI=,)%>)))) AND (GNGNTP.CDGENTYPE IS NULL OR (GNGNTP.CDGENTYPE IS NOT NULL AND (GNGNTP.CDTYPEROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=GNGNTP.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=7445 OR 1072=-1))))) AND (GNACT2.CDGENACTIVITY IS NOT NULL OR (GNACT2.CDGENACTIVITY IS NULL AND (GNACT.CDACTACCESSROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=GNACT.CDACTACCESSROLE AND (CHKPERMTYPEROLE.CDUSER=7445 OR 1072=-1))))) AND (GNACT2.CDGENACTIVITY IS NULL OR (GNACT2.CDGENACTIVITY IS NOT NULL AND (GNACT2.CDACTACCESSROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=GNACT2.CDACTACCESSROLE AND (CHKPERMTYPEROLE.CDUSER=7445 OR 1072=-1)))))
