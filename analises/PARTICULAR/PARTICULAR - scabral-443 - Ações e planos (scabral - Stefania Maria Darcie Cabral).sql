SELECT CASE WHEN GNACT.FGSTATUS=1 OR GNACT.FGSTATUS=2 THEN CASE WHEN (TMCPLAN.FGIMMEDIATEACTION=2 OR TMCPLAN.FGIMMEDIATEACTION IS NULL) THEN CASE WHEN (GNACT.DTSTARTPLAN IS NOT NULL AND GNACT.DTSTARTPLAN < <!%TODAY%>) THEN '#{100899}' WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTSTARTPLAN >= <!%TODAY%>) THEN '#{100900}' END ELSE '#{100900}' END WHEN GNACT.FGSTATUS=3 OR GNACT.FGSTATUS=13 THEN CASE WHEN (GNACT.DTFINISH IS NOT NULL) THEN CASE WHEN (GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN '#{100900}' WHEN (GNACT.DTFINISH > GNACT.DTFINISHPLAN) THEN '#{100899}' END WHEN (GNACT.DTFINISH IS NULL) THEN CASE WHEN (GNACT.DTFINISHPLAN < <!%TODAY%>) THEN '#{100899}' WHEN (GNACT.DTFINISHPLAN > dbo.SEF_DTEND_WK_DAYS_PERIOD(<!%TODAY%>, 6, (CASE WHEN GNACT2.CDGENACTIVITY IS NOT NULL THEN GNACT2.CDCALENDAR ELSE GNACT.CDCALENDAR END))) THEN '#{100900}' ELSE '#{201639}' END END WHEN GNACT.FGSTATUS=5 OR GNACT.FGSTATUS=4 THEN CASE WHEN (GNACT.DTSTARTPLAN IS NULL OR GNACT.DTFINISH <= GNACT.DTFINISHPLAN) THEN '#{100900}' ELSE '#{100899}' END END AS NMDEADLINE, CASE WHEN GNACT.FGSTATUS=1 THEN '#{100470}' WHEN GNACT.FGSTATUS=2 THEN '#{200135}' WHEN GNACT.FGSTATUS=3 THEN '#{200002}' WHEN GNACT.FGSTATUS=4 AND GNACT.CDACTIVITYOWNER IS NOT NULL THEN '#{218317}' WHEN GNACT.FGSTATUS=4 AND GNACT.CDACTIVITYOWNER IS NULL THEN '#{100476}' WHEN GNACT.FGSTATUS=5 THEN '#{101237}' WHEN GNACT.FGSTATUS=6 THEN '#{104230}' END AS NMACTSTATUS, GNACT.CDGENACTIVITY, GNACT.DTSTARTPLAN, GNACT.DTSTART, GNACT.DTFINISHPLAN, GNACT.DTFINISH, GNACT.VLPERCENTAGEM, GNCOST.MNCOSTPROG, GNCOST.MNCOSTREAL, GNACT2.IDACTIVITY AS IDACTIONPLAN, GNACT2.NMACTIVITY AS NMACTIONPLAN, GNACT.IDACTIVITY, GNACT.NMACTIVITY, GNGNTP.IDGENTYPE, GNGNTP.NMGENTYPE, ADUSR.IDUSER AS IDTASKRESP, ADUSR.NMUSER AS NMTASKRESP, ADUSRESPACTION3.NMUSER AS NMACTIONPLANRESP, GNRESUACT.NMEVALRESULT AS NMEVALRESULTACT, (CASE WHEN (ATEAM.IDTEAM IS NOT NULL) THEN ATEAM.IDTEAM + ' - ' + ATEAM.NMTEAM ELSE CAST(NULL AS VARCHAR(255)) END) AS IDNMTEAM, CASE WHEN (AD.IDDEPARTMENT IS NOT NULL) THEN AD.IDDEPARTMENT + ' - ' + AD.NMDEPARTMENT ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMDEPTUSERRESP, CASE WHEN (AP.IDPOSITION IS NOT NULL) THEN AP.IDPOSITION + ' - ' + AP.NMPOSITION ELSE CAST(NULL AS VARCHAR(255)) END AS IDNMPOSUSERRESP, GNT.CDCYCLEPLAN, CASE WHEN GNAPR.FGAPPROV=1 THEN '#{100558}' WHEN GNAPR.FGAPPROV=2 THEN '#{100761}' ELSE NULL END AS FGAPPROV, 1 AS QTD, CASE WHEN GNAPRACT.FGAPPROV=1 THEN '#{100558}' WHEN (GNAPRACT.FGAPPROV IS NULL AND GNAPPEXECACTION.NRLASTCYCLE > 1) THEN '#{100761}' ELSE NULL END AS FGAPPROVACTOPM, GNAPPEXECACTION.NRLASTCYCLE AS CDCYCLEACTION FROM GNTMCACTIONPLAN TMCPLAN INNER JOIN GNACTIVITY GNACT ON (GNACT.CDGENACTIVITY=TMCPLAN.CDGENACTIVITY AND TMCPLAN.FGPLAN=2 AND GNACT.CDISOSYSTEM=174) LEFT OUTER JOIN ADUSER ADUSR ON (ADUSR.CDUSER=GNACT.CDUSER) LEFT OUTER JOIN ADUSER ADUSR2 ON (ADUSR2.CDUSER=GNACT.CDUSERACTIVRESP) LEFT OUTER JOIN GNGENTYPE GNGNTP ON (GNGNTP.CDGENTYPE=TMCPLAN.CDACTIONPLANTYPE) LEFT OUTER JOIN GNCOSTCONFIG GNCOST ON (GNACT.CDCOSTCONFIG=GNCOST.CDCOSTCONFIG) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRESACT ON (GNEVALRESACT.CDEVALRESULTUSED=GNACT.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESUACT ON (GNRESUACT.CDEVALRESULT=GNEVALRESACT.CDEVALRESULT) LEFT OUTER JOIN GNEVALREVISION GNREVACT ON (GNREVACT.CDEVAL=GNRESUACT.CDEVAL AND GNREVACT.CDREVISION=GNRESUACT.CDREVISION) LEFT OUTER JOIN GNACTIVITY GNACT2 ON (GNACT2.CDGENACTIVITY=GNACT.CDACTIVITYOWNER AND GNACT2.CDISOSYSTEM=174) LEFT OUTER JOIN ADUSER ADUSR3 ON (ADUSR3.CDUSER=GNACT2.CDUSER) LEFT OUTER JOIN ADUSER ADUSR4 ON (ADUSR4.CDUSER=GNACT2.CDUSERACTIVRESP) LEFT OUTER JOIN GNACTIONPLAN GNACTPL ON (GNACTPL.CDGENACTIVITY=GNACT2.CDGENACTIVITY) LEFT OUTER JOIN ADUSERDEPTPOS ADUD ON (ADUSR.CDUSER=ADUD.CDUSER AND ADUD.FGDEFAULTDEPTPOS=1) LEFT OUTER JOIN ADDEPARTMENT AD ON (ADUD.CDDEPARTMENT=AD.CDDEPARTMENT) LEFT OUTER JOIN ADPOSITION AP ON (ADUD.CDPOSITION=AP.CDPOSITION) LEFT OUTER JOIN GNGENTYPE GNGNTP2 ON (GNGNTP2.CDGENTYPE=GNACTPL.CDACTIONPLANTYPE) LEFT OUTER JOIN ADTEAM ATEAM ON (ATEAM.CDTEAM=GNACT.CDTEAM) LEFT OUTER JOIN GNEVALRESULTUSED GNEVALRES ON (GNEVALRES.CDEVALRESULTUSED=GNACT2.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNRESU ON (GNRESU.CDEVALRESULT=GNEVALRES.CDEVALRESULT) LEFT OUTER JOIN GNEVALREVISION GNREV ON (GNREV.CDEVAL=GNRESU.CDEVAL AND GNREV.CDREVISION=GNRESU.CDREVISION) LEFT OUTER JOIN GNAPPROV GNAPPEXEC ON (GNACT2.CDEXECROUTE=GNAPPEXEC.CDAPPROV AND GNACT2.CDPRODROUTE=GNAPPEXEC.CDPROD) LEFT OUTER JOIN GNAPPROV GNAPPEXECACTION ON (GNACT.CDEXECROUTE=GNAPPEXECACTION.CDAPPROV AND GNACT.CDPRODROUTE=GNAPPEXECACTION.CDPROD) LEFT OUTER JOIN (SELECT TOOLACT.CDGENACTIVITY, COUNT(1) AS QTD FROM GNSTRUCT INNER JOIN (SELECT CDSTRUCT, CDCAUSE, NMCAUSE FROM PBSTRUCTCAUSE UNION/**/ ALL SELECT CDSTRUCT, CDCAUSE, NULL AS NMCAUSE FROM RISTRUCTCAUSE) STRUC ON STRUC.CDSTRUCT=GNSTRUCT.CDSTRUCT INNER JOIN (SELECT PB.CDTOOLSANALISYS, GNACTT.CDGENACTIVITY, 8 AS FGOBJECT FROM PBPROBLEM PB INNER JOIN INOCCURRENCE INO ON INO.CDOCCURRENCE=PB.CDOCCURRENCE INNER JOIN WFPROCESS WF ON WF.IDOBJECT=INO.IDWORKFLOW INNER JOIN GNACTIVITY GNACT3 ON GNACT3.CDGENACTIVITY=WF.CDGENACTIVITY INNER JOIN GNASSOCACTIONPLAN GNASP ON GNASP.CDASSOC=GNACT3.CDASSOC INNER JOIN (SELECT GNACTIVITY.CDGENACTIVITY, GNACTIVITY.CDACTIVITYOWNER AS CDACTASSOC FROM GNACTIVITY WHERE GNACTIVITY.CDISOSYSTEM=174 AND EXISTS (SELECT 1 FROM GNACTIONPLAN WHERE GNACTIONPLAN.CDGENACTIVITY=GNACTIVITY.CDACTIVITYOWNER AND GNACTIONPLAN.FGOBJECT=8) UNION/**/ ALL SELECT GNACTIVITY.CDGENACTIVITY, GNACTIVITY.CDGENACTIVITY AS CDACTASSOC FROM GNACTIVITY WHERE GNACTIVITY.CDISOSYSTEM=174 AND EXISTS (SELECT 1 FROM GNTASK WHERE GNTASK.CDGENACTIVITY=GNACTIVITY.CDGENACTIVITY AND GNTASK.FGOBJECT=8)) GNACTT ON GNACTT.CDACTASSOC=GNASP.CDACTIONPLAN UNION/**/ ALL SELECT RI.CDTOOLSANALISYS, GNAT.CDGENACTIVITY, 13 AS FGOBJECT FROM GNACTIVITY GNAT INNER JOIN GNACTIVITY GNAP ON GNAP.CDGENACTIVITY=GNAT.CDACTIVITYOWNER INNER JOIN GNASSOCACTIONPLAN GNSSC ON GNSSC.CDACTIONPLAN=GNAP.CDGENACTIVITY INNER JOIN RIRISKANALYSIS RI ON GNSSC.CDASSOC=RI.CDASSOC INNER JOIN GNASSOCRISKANA GNARA ON GNARA.CDRISKANALYSIS=RI.CDRISKANALYSIS INNER JOIN RIPLAN RP ON RP.CDPLAN=GNARA.CDPLAN AND RP.CDREVISION=GNARA.CDREVISION WHERE GNAT.CDISOSYSTEM=174 AND GNAP.CDISOSYSTEM=174 AND (RP.FGCURRENT=1 OR (RP.FGCURRENT=2 AND EXISTS (SELECT MAX(A.CDREVISION) FROM RIPLAN A WHERE A.CDPLAN=RP.CDPLAN HAVING COUNT(1)=1))) AND EXISTS (SELECT 1 FROM GNACTIONPLAN WHERE GNACTIONPLAN.CDGENACTIVITY=GNAP.CDGENACTIVITY AND GNACTIONPLAN.FGOBJECT=13)) TOOLACT ON TOOLACT.CDTOOLSANALISYS=GNSTRUCT.CDTOOLANALYSIS WHERE TOOLACT.CDTOOLSANALISYS IS NOT NULL AND (TOOLACT.FGOBJECT=8 OR (TOOLACT.FGOBJECT=13 AND GNSTRUCT.FGCAUSETYPE IS NOT NULL)) GROUP BY TOOLACT.CDGENACTIVITY) CAUSES ON CAUSES.CDGENACTIVITY=GNACT.CDGENACTIVITY LEFT OUTER JOIN (SELECT CDASSOC, COUNT(1) AS QTD FROM GNASSOCATTACH GROUP BY CDASSOC) ATTACHASSOC ON ATTACHASSOC.CDASSOC=GNACT.CDASSOC LEFT OUTER JOIN (SELECT CDASSOC, COUNT(1) AS QTD FROM GNASSOCDOCUMENT GROUP BY CDASSOC) DOCASSOC ON DOCASSOC.CDASSOC=GNACT.CDASSOC LEFT OUTER JOIN ADUSER ADUSRESPACTION3 ON (ADUSRESPACTION3.CDUSER=GNACT2.CDUSERACTIVRESP) LEFT OUTER JOIN GNTASK GNT ON (GNT.CDGENACTIVITY=GNACT.CDGENACTIVITY AND GNT.CDCYCLEPLAN IS NOT NULL) LEFT OUTER JOIN (SELECT GNAPPROVRESP.CDAPPROV,  GNAPPROVRESP.CDCYCLE,  GNAPPROVRESP.CDPROD,  MAX(GNAPPROVRESP.FGAPPROV) AS FGAPPROV FROM GNAPPROVRESP INNER JOIN GNACTIVITY ON (GNACTIVITY.CDEXECROUTE=GNAPPROVRESP.CDAPPROV  AND GNACTIVITY.CDPRODROUTE=GNAPPROVRESP.CDPROD) INNER JOIN GNACTIONPLAN ON (GNACTIONPLAN.CDGENACTIVITY=GNACTIVITY.CDGENACTIVITY) GROUP BY GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD) GNAPR ON (GNACT2.CDEXECROUTE=GNAPR.CDAPPROV AND GNACT2.CDPRODROUTE=GNAPR.CDPROD AND GNAPR.CDCYCLE=GNT.CDCYCLEPLAN) LEFT OUTER JOIN (SELECT GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD, MAX(GNAPPROVRESP.FGAPPROV) AS FGAPPROV FROM GNAPPROVRESP INNER JOIN GNACTIVITY ON GNACTIVITY.CDEXECROUTE=GNAPPROVRESP.CDAPPROV AND GNACTIVITY.CDPRODROUTE=GNAPPROVRESP.CDPROD INNER JOIN GNTASK ON GNTASK.CDGENACTIVITY=GNACTIVITY.CDGENACTIVITY GROUP BY GNAPPROVRESP.CDAPPROV, GNAPPROVRESP.CDCYCLE, GNAPPROVRESP.CDPROD) GNAPRACT ON GNAPRACT.CDAPPROV=GNACT.CDEXECROUTE AND GNAPRACT.CDPROD=GNACT.CDPRODROUTE AND GNAPRACT.CDCYCLE=GNAPPEXECACTION.NRLASTCYCLE WHERE 1=1 AND (GNACT.CDACTIVITYOWNER IS NULL OR (GNACT.CDACTIVITYOWNER IS NOT NULL AND GNACTPL.FGMODEL=2 AND EXISTS (SELECT 1 FROM ADMINISTRATION WHERE COALESCE(GNACTPL.FGOBJECT,-1) <> 9 /**/UNION/**/ ALL SELECT 1 FROM ADMINISTRATION WHERE GNACTPL.FGOBJECT=9 AND (NOT EXISTS (SELECT 1 FROM GNASSOCACTIONPLAN GNACPLAPDI WHERE GNACPLAPDI.CDACTIONPLAN=GNACTPL.CDGENACTIVITY) OR EXISTS (SELECT 1 FROM GNACTIVITY GNACTPDI INNER JOIN GNASSOCACTIONPLAN GNACPLAPDI ON ( GNACPLAPDI.CDACTIONPLAN=GNACTPDI.CDGENACTIVITY) INNER JOIN TRHISTORICAL HIPDI ON ( GNACPLAPDI.CDASSOC=HIPDI.CDASSOC) LEFT OUTER JOIN (/* Pares */ SELECT ADU1.CDUSER, CAST(8360 AS NUMERIC(10)) AS CDUSERDATA FROM ADUSER ADU1 INNER JOIN ADUSER ADU2 ON (ADU2.CDUSER <> ADU1.CDUSER) INNER JOIN ADPARAMS ADP0 ON (ADP0.CDPARAM=3  AND ADP0.CDISOSYSTEM=153  AND ADP0.VLPARAM=1) INNER JOIN ADPARAMS ADP1 ON (ADP1.CDPARAM=20  AND ADP1.CDISOSYSTEM=153) INNER JOIN ADPARAMS ADP2 ON (ADP2.CDPARAM=21  AND ADP2.CDISOSYSTEM=153) INNER JOIN ADPARAMS ADP3 ON (ADP3.CDPARAM=22  AND ADP3.CDISOSYSTEM=153) WHERE 1=1 AND EXISTS ( SELECT 1  FROM ADMINISTRATION  WHERE ADU2.CDLEADER=ADU1.CDLEADER  AND ADP1.VLPARAM=1  AND (ADP2.VLPARAM <> 1 OR ADP3.VLPARAM=2) /**/UNION/**/ ALL SELECT 1  FROM ADUSERDEPTPOS ADUDP1 INNER JOIN ADUSERDEPTPOS ADUDP2 ON ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  WHERE ADUDP1.CDUSER=ADU1.CDUSER  AND ADUDP2.CDUSER=ADU2.CDUSER  AND ADP2.VLPARAM=1  AND (ADP1.VLPARAM <> 1 OR ADP3.VLPARAM=2) /**/UNION/**/ ALL SELECT 1  FROM ADUSERDEPTPOS ADUDP1 INNER JOIN ADUSERDEPTPOS ADUDP2 ON ( ADUDP2.CDDEPARTMENT=ADUDP1.CDDEPARTMENT AND ADUDP2.CDPOSITION=ADUDP1.CDPOSITION)  WHERE ADUDP1.CDUSER=ADU1.CDUSER  AND ADUDP2.CDUSER=ADU2.CDUSER  AND ADU2.CDLEADER=ADU1.CDLEADER  AND ADP1.VLPARAM=1  AND ADP2.VLPARAM=1  AND ADP3.VLPARAM=1) AND ADU2.CDUSER=8360 GROUP BY ADU1.CDUSER /**/UNION/**/ /* Lider */ SELECT ADL.CDLEADER AS CDUSER, CAST(8360 AS NUMERIC(10)) AS CDUSERDATA FROM ADUSER ADL INNER JOIN ADPARAMS ADP ON (ADP.CDPARAM=4  AND ADP.CDISOSYSTEM=153  AND ADP.VLPARAM=1) WHERE ADL.CDLEADER IS NOT NULL AND ADL.CDUSER=8360 GROUP BY ADL.CDLEADER /**/UNION/**/ /* Liderados */ SELECT T.CDUSER, CAST(8360 AS NUMERIC(10)) AS CDUSERDATA FROM (SELECT ADU1.CDUSER, ADU0.CDUSER AS CDLEADER, 1 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) WHERE ADU0.CDUSER=8360 UNION/**/ SELECT ADU2.CDUSER, ADU0.CDUSER AS CDLEADER, 2 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) WHERE ADU0.CDUSER=8360 UNION/**/ SELECT ADU3.CDUSER, ADU0.CDUSER AS CDLEADER, 3 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) WHERE ADU0.CDUSER=8360 UNION/**/ SELECT ADU4.CDUSER, ADU0.CDUSER AS CDLEADER, 4 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) WHERE ADU0.CDUSER=8360 UNION/**/ SELECT ADU5.CDUSER, ADU0.CDUSER AS CDLEADER, 5 AS NRLEVEL FROM ADUSER ADU0 INNER JOIN ADUSER ADU1 ON (ADU1.CDLEADER=ADU0.CDUSER) INNER JOIN ADUSER ADU2 ON (ADU2.CDLEADER=ADU1.CDUSER) INNER JOIN ADUSER ADU3 ON (ADU3.CDLEADER=ADU2.CDUSER) INNER JOIN ADUSER ADU4 ON (ADU4.CDLEADER=ADU3.CDUSER) INNER JOIN ADUSER ADU5 ON (ADU5.CDLEADER=ADU4.CDUSER) WHERE ADU0.CDUSER=8360) T INNER JOIN ADPARAMS ADP ON (ADP.CDPARAM=2  AND ADP.CDISOSYSTEM=153  AND ADP.VLPARAM=1) GROUP BY T.CDUSER /**/UNION/**/ /* Proprio usuario */ SELECT CAST(8360 AS NUMERIC(10)) AS CDUSER, CAST(8360 AS NUMERIC(10)) AS CDUSERDATA FROM ADMINISTRATION /**/UNION/**/ /* Equipe de controle por unidade organizacional */ SELECT ADUDPPOS.CDUSER, CAST(8360 AS NUMERIC(10)) AS CDUSERDATA FROM ADDEPARTMENT ADP INNER JOIN ADDEPTSUBLEVEL ADDPSUB ON (ADDPSUB.CDOWNER=ADP.CDDEPARTMENT) INNER JOIN ADUSERDEPTPOS ADUDPPOS ON (ADUDPPOS.CDDEPARTMENT=ADDPSUB.CDDEPT) INNER JOIN ADTEAMUSER ADTU ON (ADTU.CDTEAM=ADP.CDSECURITYTEAM) WHERE ADTU.CDUSER=8360 GROUP BY ADUDPPOS.CDUSER) USERPERM ON (USERPERM.CDUSER=HIPDI.CDUSER AND USERPERM.CDUSERDATA=8360) WHERE GNACTPDI.CDGENACTIVITY=GNACTPL.CDGENACTIVITY AND (EXISTS (SELECT ADT1.CDUSER FROM ADTEAMUSER ADT1  INNER JOIN ADPARAMS ADP  ON (ADP.CDPARAM=1 AND ADP.CDISOSYSTEM=153 AND ADP.VLPARAM=ADT1.CDTEAM) WHERE ADT1.CDUSER=8360)  OR USERPERM.CDUSER IS NOT NULL)))))) AND (GNGNTP.CDGENTYPE IS NULL OR (GNGNTP.CDGENTYPE IS NOT NULL AND (GNGNTP.CDTYPEROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=GNGNTP.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=8360 OR 8360=-1))))) AND (TMCPLAN.CDACTACCESSROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=TMCPLAN.CDACTACCESSROLE AND (CHKPERMTYPEROLE.CDUSER=8360 OR 8360=-1)))
