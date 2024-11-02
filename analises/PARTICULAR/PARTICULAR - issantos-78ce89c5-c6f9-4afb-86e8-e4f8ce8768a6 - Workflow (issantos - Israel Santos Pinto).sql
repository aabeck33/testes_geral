SELECT NMDEADLINE,IDPROCESS,NMUSERSTART,TYPEUSER,DTSTART,IDLEVEL,DTDEADLINEFIELD,NMEVALRESULT,NMPROCESSMODEL,IDSITUATION,IDREVISIONSTATUS,NMREVISIONSTATUS,IDSLASTATUS,DURATION_WF,NMOCCURRENCETYPE,NMPROCESS,IDPROCESSTYPE,IDREVISION,FGDEADLINE,FGTYPEUSER,FGSTATUS,FGSLASTATUS,T0__ITSM004_1,T0__ITSM034_2,T0__ITSM035_0,T0__ITSM006_1,T0__ITSM002_1,T0__ITSM003_1,T0__ITSM036_1 FROM (SELECT NMDEADLINE,IDPROCESS,NMUSERSTART,TYPEUSER,DTSTART,IDLEVEL,DTDEADLINEFIELD,NMEVALRESULT,NMPROCESSMODEL,IDSITUATION,IDREVISIONSTATUS,NMREVISIONSTATUS,IDSLASTATUS,DURATION_WF,NMOCCURRENCETYPE,NMPROCESS,IDPROCESSTYPE,IDREVISION,FGDEADLINE,FGTYPEUSER,FGSTATUS,FGSLASTATUS,T0__ITSM004_1,T0__ITSM034_2,T0__ITSM035_0,T0__ITSM006_1,T0__ITSM002_1,T0__ITSM003_1,T0__ITSM036_1 FROM (SELECT 1 AS QTD, WFP.IDPROCESS, WFP.NMPROCESS, WFP.NMPROCESSMODEL, WFP.NMUSERSTART, CASE WHEN WFP.CDEXTERNALUSERSTART IS NOT NULL THEN '#{303826}' WHEN WFP.CDUSERSTART IS NOT NULL THEN '#{305843}' ELSE NULL END AS TYPEUSER, CASE WHEN WFP.CDEXTERNALUSERSTART IS NOT NULL THEN 2 WHEN WFP.CDUSERSTART IS NOT NULL THEN 1 ELSE NULL END AS FGTYPEUSER, (SELECT GNT.NMGENTYPE FROM GNGENTYPE GNT WHERE WFP.CDWORKFLOWTYPE=GNT.CDGENTYPE) AS NMOCCURRENCETYPE, GNRS.IDREVISIONSTATUS, GNRS.NMREVISIONSTATUS, CASE WHEN WFP.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN WFP.FGCONCLUDEDSTATUS=1 THEN '#{100900}' WHEN WFP.FGCONCLUDEDSTATUS=2 THEN '#{100899}' END) ELSE (CASE WHEN (( WFP.DTESTIMATEDFINISH > (DATEADD(DAY, COALESCE((SELECT QTDAYS FROM ADMAILTASKEXEC WHERE CDMAILTASKEXEC=(SELECT TASK.CDAHEAD FROM ADMAILTASKREL TASK WHERE TASK.CDMAILTASKREL=(SELECT TBL.CDMAILTASKSETTINGS FROM CONOTIFICATION TBL))), 0), CAST(<!%TODAY%> AS DATETIME)))) OR (WFP.DTESTIMATEDFINISH IS NULL)) THEN '#{100900}' WHEN (( WFP.DTESTIMATEDFINISH=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND WFP.NRTIMEESTFINISH >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (WFP.DTESTIMATEDFINISH > CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME))) THEN '#{201639}' ELSE '#{100899}' END) END AS NMDEADLINE, CASE WHEN WFP.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN WFP.FGCONCLUDEDSTATUS=1 THEN 1 WHEN WFP.FGCONCLUDEDSTATUS=2 THEN 3 END) ELSE (CASE WHEN (( WFP.DTESTIMATEDFINISH > (DATEADD(DAY, COALESCE((SELECT QTDAYS FROM ADMAILTASKEXEC WHERE CDMAILTASKEXEC=(SELECT TASK.CDAHEAD FROM ADMAILTASKREL TASK WHERE TASK.CDMAILTASKREL=(SELECT TBL.CDMAILTASKSETTINGS FROM CONOTIFICATION TBL))), 0), CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME)))) OR (WFP.DTESTIMATEDFINISH IS NULL)) THEN 1 WHEN (( WFP.DTESTIMATEDFINISH=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND WFP.NRTIMEESTFINISH >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (WFP.DTESTIMATEDFINISH > CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME))) THEN 2 ELSE 3 END) END AS FGDEADLINE, WFP.FGSLASTATUS, CASE WFP.FGSLASTATUS WHEN 10 THEN '#{218492}' WHEN 30 THEN '#{218493}' WHEN 40 THEN '#{218494}' END AS IDSLASTATUS, WFP.FGSTATUS, CASE WFP.FGSTATUS WHEN 1 THEN '#{103131}' WHEN 2 THEN '#{107788}' WHEN 3 THEN '#{104230}' WHEN 4 THEN '#{100667}' WHEN 5 THEN '#{200712}' END AS IDSITUATION, GNR.NMEVALRESULT, (SELECT MAX(IDLEVEL) FROM GNSLACTRLHISTORY WHERE CDSLACONTROL=WFP.CDSLACONTROL AND FGCURRENT=1) AS IDLEVEL, WFP.IDPROCESSTYPE, WFP.IDREVISION, CASE WHEN WFP.FGSTATUS IN (1,2,3,5) THEN (CAST(FLOOR(CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))) AS VARCHAR) + LOWER(' #{108037} ') + CAST(FLOOR((CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24) AS VARCHAR) + LOWER(' #{101173} ') + CAST(FLOOR((((CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24) - FLOOR((CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + LOWER(' #{101181} ')) WHEN WFP.FGSTATUS=4 THEN (CAST(FLOOR(CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))) AS VARCHAR) + LOWER(' #{108037} ') + CAST(FLOOR((CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24) AS VARCHAR) + LOWER(' #{101173} ') + CAST(FLOOR((((CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24) - FLOOR((CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((WFP.DTFINISH+' '+WFP.TMFINISH) - (WFP.DTSTART+' '+WFP.TMSTART)) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + LOWER(' #{101181} ')) END AS DURATION_WF, Dateadd(minute, WFP.NRTIMEESTFINISH, WFP.DTESTIMATEDFINISH) AS DTDEADLINEFIELD, CONVERT(DATETIME, WFP.DTSTART + ' ' + WFP.TMSTART, 120) AS DTSTART, T0_OUTER.T0__ITSM004_1, T0_OUTER.T0__ITSM034_2, T0_OUTER.T0__ITSM035_0, T0_OUTER.T0__ITSM006_1, T0_OUTER.T0__ITSM002_1, T0_OUTER.T0__ITSM003_1, T0_OUTER.T0__ITSM036_1 FROM WFPROCESS WFP LEFT OUTER JOIN GNREVISIONSTATUS GNRS ON WFP.CDSTATUS=GNRS.CDREVISIONSTATUS LEFT OUTER JOIN GNEVALRESULTUSED GNRUS ON GNRUS.CDEVALRESULTUSED=WFP.CDEVALRSLTPRIORITY LEFT OUTER JOIN GNEVALRESULT GNR ON GNRUS.CDEVALRESULT=GNR.CDEVALRESULT LEFT OUTER JOIN (SELECT FORMREG.CDASSOC, T0.ITSM004 AS T0__ITSM004_1, T0.ITSM034 AS T0__ITSM034_2, T0.ITSM035 AS T0__ITSM035_0, T0.ITSM006 AS T0__ITSM006_1, T0.ITSM002 AS T0__ITSM002_1, T0.ITSM003 AS T0__ITSM003_1, T0.ITSM036 AS T0__ITSM036_1 FROM GNASSOCFORMREG FORMREG INNER JOIN DYNitsm T0 ON (FORMREG.OIDENTITYREG=T0.OID)) T0_OUTER ON (T0_OUTER.CDASSOC=WFP.CDASSOCREG) INNER JOIN (SELECT DISTINCT Z.IDOBJECT FROM (SELECT AUXWFP.IDOBJECT FROM WFPROCESS AUXWFP INNER JOIN (SELECT PERM.USERCD, PERM.IDPROCESS, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WF.FGPERMISSION, WF.IDPROCESS, TM.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADTEAMUSER TM ON WF.CDTEAM=TM.CDTEAM WHERE WF.FGACCESSTYPE=1 AND TM.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE WF.FGACCESSTYPE=2 AND UDP.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT AND WF.CDPOSITION=UDP.CDPOSITION WHERE WF.FGACCESSTYPE=3 AND UDP.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDPOSITION=UDP.CDPOSITION WHERE WF.FGACCESSTYPE=4 AND UDP.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WF.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF WHERE WF.FGACCESSTYPE=5 AND WF.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF CROSS JOIN ADUSER US WHERE WF.FGACCESSTYPE=6 AND US.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, RL.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERROLE RL ON RL.CDROLE=WF.CDROLE WHERE WF.FGACCESSTYPE=7 AND RL.CDUSER=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WFP.CDUSERSTART AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS WHERE WF.FGACCESSTYPE=30 AND WFP.CDUSERSTART=15611 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDLEADER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE WF.FGACCESSTYPE=31 AND US.CDLEADER=15611 AND WF.FGACCESSEXCEPTION IS NULL) PERM INNER JOIN WFPROCSECURITYCTRL GNASSOC ON (GNASSOC.CDACCESSLIST=PERM.CDACCESSLIST AND GNASSOC.IDPROCESS=PERM.IDPROCESS) WHERE GNASSOC.CDACCESSROLEFIELD IN (501) GROUP BY PERM.USERCD, PERM.IDPROCESS) PERMISSION ON PERMISSION.IDPROCESS=AUXWFP.IDOBJECT WHERE PERMISSION.FGPERMISSION=1 AND AUXWFP.FGSTATUS <= 5 AND (AUXWFP.FGMODELWFSECURITY IS NULL OR AUXWFP.FGMODELWFSECURITY=0) UNION ALL SELECT T.IDOBJECT FROM (SELECT MIN(PERM99.FGPERMISSION) AS FGPERMISSION, PERM99.IDOBJECT FROM (SELECT WFP.IDOBJECT, PERM1.FGPERMISSION FROM (SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADTEAMUSER TM ON PP.CDTEAM=TM.CDTEAM WHERE PP.FGACCESSTYPE=1 AND TM.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE PP.FGACCESSTYPE=2 AND UDP.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON (PP.CDDEPARTMENT=UDP.CDDEPARTMENT AND PP.CDPOSITION=UDP.CDPOSITION) WHERE PP.FGACCESSTYPE=3 AND UDP.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDPOSITION=UDP.CDPOSITION WHERE PP.FGACCESSTYPE=4 AND UDP.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, PP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP WHERE PP.FGACCESSTYPE=5 AND PP.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, US.CDUSER AS USERCD FROM PMPROCACCESSLIST PP CROSS JOIN ADUSER US WHERE PP.FGACCESSTYPE=6 AND US.CDUSER=15611 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERROLE RL ON RL.CDROLE=PP.CDROLE WHERE PP.FGACCESSTYPE=7 AND RL.CDUSER=15611) PERM1 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON (PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDPROC=GNASSOC.CDPROC) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PERM1.CDPROC WHERE GNCTRL.CDRELATEDFIELD IN (501) AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL) AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PERM2.IDOBJECT, PERM2.FGPERMISSION FROM (SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, WFP.CDUSERSTART AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC WHERE PP.FGACCESSTYPE=30 AND WFP.CDUSERSTART=15611 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, US.CDLEADER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE PP.FGACCESSTYPE=31 AND US.CDLEADER=15611 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5) PERM2 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON (PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDPROC=GNASSOC.CDPROC) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY WHERE GNCTRL.CDRELATEDFIELD IN (501) AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL)) PERM99 WHERE 1=1 GROUP BY PERM99.IDOBJECT) T WHERE T.FGPERMISSION=1 UNION ALL SELECT PERM.IDOBJECT FROM (SELECT WFP.IDOBJECT FROM (SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN ADTEAMUSER TM ON PM.CDTEAM=TM.CDTEAM WHERE PM.FGACCESSTYPE=1 AND TM.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE PM.FGACCESSTYPE=2 AND UDP.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT AND PM.CDPOSITION=UDP.CDPOSITION WHERE PM.FGACCESSTYPE=3 AND UDP.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDPOSITION=UDP.CDPOSITION WHERE PM.FGACCESSTYPE=4 AND UDP.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM WHERE PM.FGACCESSTYPE=5 AND PM.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM WHERE PM.FGACCESSTYPE=6 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERROLE RL ON RL.CDROLE=PM.CDROLE WHERE PM.FGACCESSTYPE=7 AND RL.CDUSER=15611) PERM1 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM1.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT WFP.IDOBJECT FROM (SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE WHERE PM.FGACCESSTYPE=8 AND PMA.CDCREATEDBY=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT WHERE PM.FGACCESSTYPE=9 AND DEP2.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON (DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT AND DEP2.CDPOSITION=DEP1.CDPOSITION) WHERE PM.FGACCESSTYPE=10 AND DEP2.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDPOSITION=DEP1.CDPOSITION WHERE PM.FGACCESSTYPE=11 AND DEP2.CDUSER=15611 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSER US ON US.CDUSER=PMA.CDCREATEDBY WHERE PM.FGACCESSTYPE=12 AND US.CDLEADER=15611) PERM2 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM2.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PERM3.IDOBJECT FROM (SELECT PM.CDACTTYPE, PM.CDACCESSLIST, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE PM.FGACCESSTYPE=30 AND WFP.CDUSERSTART=15611 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PM.CDACTTYPE, PM.CDACCESSLIST, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE PM.FGACCESSTYPE=31 AND US.CDLEADER=15611 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1) PERM3 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON (PERM3.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM3.CDACTTYPE=GNASSOC.CDACTTYPE) INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM3.CDACTTYPE=PMA.CDACTTYPE WHERE GNCTRL_F.CDRELATEDFIELD IN (501) AND PMA.FGUSETYPEACCESS=1) PERM UNION ALL SELECT AUXWFP.IDOBJECT FROM WFPROCESS AUXWFP INNER JOIN WFPROCSECURITYLIST WFLIST ON (AUXWFP.IDOBJECT=WFLIST.IDPROCESS) INNER JOIN WFPROCSECURITYCTRL WFCTRL ON (WFLIST.CDACCESSLIST=WFCTRL.CDACCESSLIST AND WFLIST.IDPROCESS=WFCTRL.IDPROCESS) WHERE WFCTRL.CDACCESSROLEFIELD IN (501) AND WFLIST.CDUSER=15611 AND WFLIST.FGACCESSTYPE=5 AND WFLIST.FGACCESSEXCEPTION=1 AND WFLIST.FGPERMISSION=1 AND AUXWFP.FGSTATUS <= 5) Z) MYPERM ON (WFP.IDOBJECT=MYPERM.IDOBJECT) WHERE WFP.FGSTATUS <= 5 AND WFP.CDPRODAUTOMATION NOT IN (160, 202, 275) AND WFP.CDPROCESSMODEL=5251 AND WFP.CDSTATUS IN (112,115,116,121,122,114,113,120,123,126,118,119,117,128,129,135,136,137,140,141,142,150,151) AND WFP.FGSTATUS IN (1,5) AND (EXISTS( SELECT 1 FROM DYNITSM FRMFILTER1 WHERE FRMFILTER1.OID IN (SELECT AREG.OIDENTITYREG FROM GNASSOCFORMREG AREG WHERE AREG.CDASSOC=WFP.CDASSOCREG) AND ((FRMFILTER1.ITSM035 LIKE '%SAPMM%'))))) TEMPTB0) TEMPTB1
