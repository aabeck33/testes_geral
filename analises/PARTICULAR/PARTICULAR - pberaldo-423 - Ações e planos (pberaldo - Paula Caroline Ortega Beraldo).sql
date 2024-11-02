SELECT CASE WHEN GNACT.FGSTATUS=1 OR GNACT.FGSTATUS=2 THEN CASE WHEN (GNACT.DTSTARTPLAN IS NOT NULL AND GNACT.DTSTARTPLAN < <!%TODAY%>) THEN 'Em atraso' WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTSTARTPLAN >= <!%TODAY%>) THEN 'Em dia' END WHEN GNACT.FGSTATUS=3 THEN CASE WHEN (GNACT.DTFINISH IS NOT NULL) THEN CASE WHEN (GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN 'Em dia' WHEN (GNACT.DTFINISH > GNACT.DTFINISHPLAN) THEN 'Em atraso' END WHEN (GNACT.DTFINISH IS NULL) THEN CASE WHEN (GNACT.DTFINISHPLAN < <!%TODAY%>) THEN 'Em atraso' WHEN (GNACT.DTFINISHPLAN > dbo.SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>, 6, (CASE WHEN GNACT2.CDGENACTIVITY IS NOT NULL THEN GNACT2.CDCALENDAR ELSE GNACT.CDCALENDAR END))) THEN 'Em dia' ELSE 'Próximo do vencimento' END END WHEN GNACT.FGSTATUS=5 OR GNACT.FGSTATUS=4 THEN CASE WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN 'Em dia' ELSE 'Em atraso' END END AS NMDEADLINE, CASE WHEN GNACT.FGSTATUS=1 THEN 'Planejamento' WHEN GNACT.FGSTATUS=2 THEN 'Aprovação do planejamento' WHEN GNACT.FGSTATUS=3 THEN 'Execução' WHEN GNACT.FGSTATUS=4 THEN 'Aprovação da execução' WHEN GNACT.FGSTATUS=5 THEN 'Encerrada' WHEN GNACT.FGSTATUS=6 THEN 'Cancelado' END AS NMACTSTATUS, GNACT.CDGENACTIVITY, GNACT.DTSTARTPLAN, GNACT.DTSTART, GNACT.DTFINISHPLAN, GNACT.DTFINISH, GNCOST.MNCOSTPROG, GNCOST.MNCOSTREAL, GNACT2.IDACTIVITY AS IDACTIONPLAN, GNACT2.NMACTIVITY AS NMACTIONPLAN, GNACT.IDACTIVITY, GNACT.NMACTIVITY, GNGNTP.IDGENTYPE, GNGNTP.NMGENTYPE, ADUSR.IDUSER AS IDTASKRESP, ADUSR.NMUSER AS NMTASKRESP, ADUSR3.NMUSER AS NMACTIONPLANRESP, CASE WHEN (AD.IDDEPARTMENT IS NOT NULL) THEN AD.IDDEPARTMENT + ' - ' + AD.NMDEPARTMENT ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMDEPTUSERRESP,  CASE WHEN (AP.IDPOSITION IS NOT NULL) THEN AP.IDPOSITION + ' - ' + AP.NMPOSITION ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMPOSUSERRESP, 1 AS QTD FROM GNTMCACTIONPLAN TMCPLAN INNER JOIN GNACTIVITY GNACT ON (GNACT.CDGENACTIVITY=TMCPLAN.CDGENACTIVITY) INNER JOIN ADUSER ADUSR ON (ADUSR.CDUSER=GNACT.CDUSER) LEFT OUTER JOIN ADUSER ADUSR2 ON (ADUSR2.CDUSER=GNACT.CDUSERACTIVRESP) LEFT OUTER JOIN GNGENTYPE GNGNTP ON (GNGNTP.CDGENTYPE=TMCPLAN.CDACTIONPLANTYPE) LEFT OUTER JOIN GNCOSTCONFIG GNCOST ON (GNACT.CDCOSTCONFIG=GNCOST.CDCOSTCONFIG) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRESACT ON (GNEVALRESACT.CDEVALRESULTUSED=GNACT.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESUACT ON (GNRESUACT.CDEVALRESULT=GNEVALRESACT.CDEVALRESULT) LEFT OUTER JOIN GNEVALREVISION GNREVACT ON (GNREVACT.CDEVAL=GNRESUACT.CDEVAL AND GNREVACT.CDREVISION=GNRESUACT.CDREVISION) LEFT OUTER JOIN GNACTIVITY GNACT2 ON (GNACT2.CDGENACTIVITY=GNACT.CDACTIVITYOWNER) LEFT OUTER JOIN GNTMCACTIONPLAN TMCPLAN2 ON (TMCPLAN2.CDGENACTIVITY=GNACT2.CDGENACTIVITY) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRES ON (GNEVALRES.CDEVALRESULTUSED=GNACT2.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESU ON (GNRESU.CDEVALRESULT=GNEVALRES.CDEVALRESULT) LEFT OUTER JOIN GNEVALREVISION GNREV ON (GNREV.CDEVAL=GNRESU.CDEVAL AND GNREV.CDREVISION=GNRESU.CDREVISION) LEFT OUTER JOIN GNACTIVITYREQUEST GNACTREQ ON (GNACTREQ.CDGENACTIVITY=GNACT.CDGENACTIVITY OR GNACTREQ.CDGENACTIVITY=GNACT2.CDGENACTIVITY) LEFT OUTER JOIN GNREQUEST GNREQ ON (GNREQ.CDREQUEST=GNACTREQ.CDREQUEST) LEFT OUTER JOIN ADUSERDEPTPOS ADUD ON (ADUSR.CDUSER=ADUD.CDUSER AND ADUD.FGDEFAULTDEPTPOS=1) LEFT OUTER JOIN ADDEPARTMENT AD ON (ADUD.CDDEPARTMENT=AD.CDDEPARTMENT) LEFT OUTER JOIN ADPOSITION AP ON (ADUD.CDPOSITION=AP.CDPOSITION) LEFT OUTER JOIN ADTEAM ATEAM ON (ATEAM.CDTEAM=GNACT.CDTEAM) LEFT OUTER JOIN GNAPPROV GNAPPEXEC ON (GNACT2.CDEXECROUTE=GNAPPEXEC.CDAPPROV AND GNACT2.CDPRODROUTE=GNAPPEXEC.CDPROD) LEFT OUTER JOIN ADUSER ADUSR3 ON (ADUSR3.CDUSER=GNACT2.CDUSERACTIVRESP) WHERE 1=1 AND (NOT EXISTS (SELECT 1 FROM GNACTIVITY GNA WHERE GNA.CDACTIVITYOWNER=GNACT.CDGENACTIVITY) AND TMCPLAN.FGMODEL <> 1 AND (TMCPLAN.FGOBJECT IS NULL OR TMCPLAN.FGOBJECT <> 9 OR (TMCPLAN.FGOBJECT=9 AND (NOT EXISTS (SELECT 1 FROM GNASSOCACTIONPLAN GNACPLAPDI WHERE GNACPLAPDI.CDACTIONPLAN=TMCPLAN.CDGENACTIVITY) OR EXISTS (SELECT 1 FROM GNACTIVITY GNACTPDI INNER JOIN GNASSOCACTIONPLAN GNACPLAPDI ON ( GNACPLAPDI.CDACTIONPLAN=GNACTPDI.CDGENACTIVITY) INNER JOIN TRHISTORICAL HIPDI ON ( GNACPLAPDI.CDASSOC=HIPDI.CDASSOC) LEFT OUTER JOIN (SELECT DISTINCT Z.CDUSER, Z.CDUSERDATA FROM (/* Pares */ SELECT ADU1.CDUSER,  ADU2.CDUSER AS CDUSERDATA FROM ADUSER ADU1  INNER JOIN ADUSER ADU2  ON (ADU1.CDUSER <> ADU2.CDUSER)  INNER JOIN ADUSERDEPTPOS ADUDP1  ON (ADUDP1.CDUSER=ADU1.CDUSER)  INNER JOIN ADUSERDEPTPOS ADUDP2  ON (ADUDP2.CDUSER=ADU2.CDUSER)  INNER JOIN ADPARAMS ADP1  ON (ADP1.CDPARAM=20 AND ADP1.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP2  ON (ADP2.CDPARAM=21 AND ADP2.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP3  ON (ADP3.CDPARAM=22 AND ADP3.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=3 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1) WHERE 1=1 AND  (( ADP1.VLPARAM=1 AND ADP2.VLPARAM=2 AND ADU2.CDLEADER=ADU1.CDLEADER)  OR (ADP2.VLPARAM=1 AND ADP1.VLPARAM=2 AND ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  OR (ADP1.VLPARAM=1 AND ADP2.VLPARAM=1 AND ADP3.VLPARAM=2 AND (( ADU2.CDLEADER=ADU1.CDLEADER) OR  ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT  AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)))  OR (ADP1.VLPARAM=1 AND ADP2.VLPARAM=1 AND ADP3.VLPARAM=1 AND (( ADU2.CDLEADER=ADU1.CDLEADER) AND  ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT  AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)))) AND ADU2.CDUSER=1072 GROUP BY ADU1.CDUSER,  ADU2.CDUSER  UNION/**/ ALL  /* Lider */ SELECT ADL.CDLEADER AS CDUSER, ADL.CDUSER AS CDUSERDATA FROM ADUSER ADL INNER JOIN ADPARAMS ADP ON ( ADP.CDPARAM=4 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1) WHERE ADL.CDLEADER IS NOT NULL AND ADL.CDUSER=1072  UNION/**/ ALL  /* Liderados */ SELECT T.CDUSER, 1072 AS CDUSERDATA FROM (SELECT ADU1.CDUSER, ADU0.CDUSER AS CDLEADER, 1 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU2.CDUSER, ADU0.CDUSER AS CDLEADER, 2 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU3.CDUSER, ADU0.CDUSER AS CDLEADER, 3 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU4.CDUSER, ADU0.CDUSER AS CDLEADER, 4 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU5.CDUSER, ADU0.CDUSER AS CDLEADER, 5 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) INNER JOIN ADUSER ADU5 ON (ADU5.CDLEADER=ADU4.CDUSER) WHERE ADU0.CDUSER=1072) T INNER JOIN ADPARAMS ADP ON ( ADP.CDPARAM=2 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1)  UNION/**/ ALL  /* Proprio usuario */ SELECT 1072 AS CDUSER, 1072 AS CDUSERDATA FROM ADMINISTRATION) Z) USERPERM ON (USERPERM.CDUSER=HIPDI.CDUSER AND USERPERM.CDUSERDATA=1072) WHERE GNACTPDI.CDGENACTIVITY=TMCPLAN.CDGENACTIVITY AND (EXISTS (SELECT ADT1.CDUSER FROM ADTEAMUSER ADT1  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=1 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=ADT1.CDTEAM) WHERE ADT1.CDUSER=1072)  OR USERPERM.CDUSER IS NOT NULL)))))) AND (GNACT.CDACTIVITYOWNER IS NULL OR (GNACT.CDACTIVITYOWNER IS NOT NULL AND TMCPLAN2.FGMODEL <> 1 AND (TMCPLAN2.FGOBJECT IS NULL OR TMCPLAN2.FGOBJECT <> 9 OR (TMCPLAN2.FGOBJECT=9 AND (NOT EXISTS (SELECT 1 FROM GNASSOCACTIONPLAN GNACPLAPDI WHERE GNACPLAPDI.CDACTIONPLAN=TMCPLAN2.CDGENACTIVITY) OR EXISTS (SELECT 1 FROM GNACTIVITY GNACTPDI INNER JOIN GNASSOCACTIONPLAN GNACPLAPDI ON ( GNACPLAPDI.CDACTIONPLAN=GNACTPDI.CDGENACTIVITY) INNER JOIN TRHISTORICAL HIPDI ON ( GNACPLAPDI.CDASSOC=HIPDI.CDASSOC) LEFT OUTER JOIN (SELECT DISTINCT Z.CDUSER, Z.CDUSERDATA FROM (/* Pares */ SELECT ADU1.CDUSER,  ADU2.CDUSER AS CDUSERDATA FROM ADUSER ADU1  INNER JOIN ADUSER ADU2  ON (ADU1.CDUSER <> ADU2.CDUSER)  INNER JOIN ADUSERDEPTPOS ADUDP1  ON (ADUDP1.CDUSER=ADU1.CDUSER)  INNER JOIN ADUSERDEPTPOS ADUDP2  ON (ADUDP2.CDUSER=ADU2.CDUSER)  INNER JOIN ADPARAMS ADP1  ON (ADP1.CDPARAM=20 AND ADP1.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP2  ON (ADP2.CDPARAM=21 AND ADP2.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP3  ON (ADP3.CDPARAM=22 AND ADP3.CDISOSYSTEM=153)  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=3 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1) WHERE 1=1 AND  (( ADP1.VLPARAM=1 AND ADP2.VLPARAM=2 AND ADU2.CDLEADER=ADU1.CDLEADER)  OR (ADP2.VLPARAM=1 AND ADP1.VLPARAM=2 AND ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  OR (ADP1.VLPARAM=1 AND ADP2.VLPARAM=1 AND ADP3.VLPARAM=2 AND (( ADU2.CDLEADER=ADU1.CDLEADER) OR  ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT  AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)))  OR (ADP1.VLPARAM=1 AND ADP2.VLPARAM=1 AND ADP3.VLPARAM=1 AND (( ADU2.CDLEADER=ADU1.CDLEADER) AND  ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT  AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)))) AND ADU2.CDUSER=1072 GROUP BY ADU1.CDUSER,  ADU2.CDUSER  UNION/**/ ALL  /* Lider */ SELECT ADL.CDLEADER AS CDUSER, ADL.CDUSER AS CDUSERDATA FROM ADUSER ADL INNER JOIN ADPARAMS ADP ON ( ADP.CDPARAM=4 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1) WHERE ADL.CDLEADER IS NOT NULL AND ADL.CDUSER=1072  UNION/**/ ALL  /* Liderados */ SELECT T.CDUSER, 1072 AS CDUSERDATA FROM (SELECT ADU1.CDUSER, ADU0.CDUSER AS CDLEADER, 1 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU2.CDUSER, ADU0.CDUSER AS CDLEADER, 2 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU3.CDUSER, ADU0.CDUSER AS CDLEADER, 3 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU4.CDUSER, ADU0.CDUSER AS CDLEADER, 4 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) WHERE ADU0.CDUSER=1072 UNION/**/ SELECT ADU5.CDUSER, ADU0.CDUSER AS CDLEADER, 5 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) INNER JOIN ADUSER ADU5 ON (ADU5.CDLEADER=ADU4.CDUSER) WHERE ADU0.CDUSER=1072) T INNER JOIN ADPARAMS ADP ON ( ADP.CDPARAM=2 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=1)  UNION/**/ ALL  /* Proprio usuario */ SELECT 1072 AS CDUSER, 1072 AS CDUSERDATA FROM ADMINISTRATION) Z) USERPERM ON (USERPERM.CDUSER=HIPDI.CDUSER AND USERPERM.CDUSERDATA=1072) WHERE GNACTPDI.CDGENACTIVITY=TMCPLAN2.CDGENACTIVITY AND (EXISTS (SELECT ADT1.CDUSER FROM ADTEAMUSER ADT1  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=1 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=ADT1.CDTEAM) WHERE ADT1.CDUSER=1072)  OR USERPERM.CDUSER IS NOT NULL))))))) AND (((TMCPLAN.CDACTIONPLANTYPE IN(<!%FUNC(com.softexpert.generic.parameter.InClauseBuilder, R05HRU5UWVBF, Q0RHRU5UWVBF, Q0RHRU5UWVBFT1dORVI=, ,NjQ=)%>))) AND ((GNGNTP.CDGENTYPE IS NULL) OR (GNGNTP.CDGENTYPE IS NOT NULL AND (GNGNTP.CDTYPEROLE IS NULL OR EXISTS (SELECT 1 FROM (SELECT MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE) AS FGACCESSLIST, CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM, ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.FGACCESSLIST=1 AND CHKPERMTYPEROLE.CDTYPEROLE=GNGNTP.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=1072 OR 1072=-1))))) OR ((TMCPLAN2.CDACTIONPLANTYPE IN(<!%FUNC(com.softexpert.generic.parameter.InClauseBuilder, R05HRU5UWVBF, Q0RHRU5UWVBF, Q0RHRU5UWVBFT1dORVI=, ,NjQ=)%>))) AND ((GNGNTP.CDGENTYPE IS NULL) OR (GNGNTP.CDGENTYPE IS NOT NULL AND (GNGNTP.CDTYPEROLE IS NULL OR EXISTS (SELECT 1 FROM (SELECT MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE) AS FGACCESSLIST, CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM, ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.FGACCESSLIST=1 AND CHKPERMTYPEROLE.CDTYPEROLE=GNGNTP.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=1072 OR 1072=-1)))))) AND ((GNGNTP.CDGENTYPE IS NULL) OR (GNGNTP.CDGENTYPE IS NOT NULL AND (GNGNTP.CDTYPEROLE IS NULL OR EXISTS (SELECT 1 FROM (SELECT MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE) AS FGACCESSLIST, CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM, ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.FGACCESSLIST=1 AND CHKPERMTYPEROLE.CDTYPEROLE=GNGNTP.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=1072 OR 1072=-1)))))
