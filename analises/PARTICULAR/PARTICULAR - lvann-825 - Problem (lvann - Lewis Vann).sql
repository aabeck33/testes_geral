SELECT ID_PROCESS,NMPROCESS,QTD_BI,IDSLASTATUS,IDLEVEL,DTSTART,NMUSERSTART,NMEVALRESULT,NMDEADLINE,IDSITUATION,DTDEADLINEFIELD,NMREVISIONSTATUS,IDREVISIONSTATUS,NMOCCURRENCETYPE,DTFINISH,DTSLAFINISH,UA060UA001,UA060UA002,UA060UA003,UA060UA004,UA060UA005,UA060UA006,UA060UA007,UA060UA008,UA060UA009,REF8888611053,REF3274142430,REF235431194,REF2048245794,REF6485986076,REF7584899067,REF1625071838,REF3954529738,REF627115955,REF304405111 FROM (SELECT ID_PROCESS,NMPROCESS,QTD_BI,IDSLASTATUS,IDLEVEL,DTSTART,NMUSERSTART,NMEVALRESULT,NMDEADLINE,IDSITUATION,DTDEADLINEFIELD,NMREVISIONSTATUS,IDREVISIONSTATUS,NMOCCURRENCETYPE,DTFINISH,DTSLAFINISH,UA060UA001,UA060UA002,UA060UA003,UA060UA004,UA060UA005,UA060UA006,UA060UA007,UA060UA008,UA060UA009,REF8888611053,REF3274142430,REF235431194,REF2048245794,REF6485986076,REF7584899067,REF1625071838,REF3954529738,REF627115955,REF304405111 FROM (SELECT CAST(ENT01.ua001 AS VARCHAR(MAX)) AS UA060UA001, ENT01.ua002 AS UA060UA002, ENT01.ua003 AS UA060UA003, CAST(ENT01.ua004 AS VARCHAR(MAX)) AS UA060UA004, CAST(ENT01.ua005 AS VARCHAR(MAX)) AS UA060UA005, CAST(ENT01.ua006 AS VARCHAR(MAX)) AS UA060UA006, ENT01.ua007 AS UA060UA007, ENT01.ua008 AS UA060UA008, ENT01.ua009 AS UA060UA009, ENT01REF01.ua001 AS REF8888611053, ENT01REF02.ua001 AS REF3274142430, ENT01REF02.ua002 AS REF235431194, ENT01REF02.ua003 AS REF2048245794, ENT01REF03.ua001 AS REF6485986076, ENT01REF03.ua002 AS REF7584899067, ENT01REF03.ua003 AS REF1625071838, ENT01REF03.ua004 AS REF3954529738, ENT01REF03.ua005 AS REF627115955, ENT01REF04.ua001 AS REF304405111, 1 AS QTD_BI, P.IDOBJECT, P.IDPROCESS AS ID_PROCESS, P.NMPROCESS, P.CDPROCESSMODEL, P.CDREVISION, P.IDPROCESSMODEL, P.NMPROCESSMODEL, P.FGSTATUS AS FGSTATUS,CONVERT(DATETIME, P.DTSTART + ' ' + P.TMSTART, 120) AS DTSTART,CONVERT(DATETIME, P.DTFINISH + ' ' + P.TMFINISH, 120) AS DTFINISH,CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(SLACTRL.BNSLAFINISH AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')) AS DTSLAFINISH, GNT.IDGENTYPE AS IDOCCURRENCETYPE, GNT.NMGENTYPE AS NMOCCURRENCETYPE, INCID.CDOCCURRENCETYPE AS CDOCCURRENCETYPE, GNT.FGLOGO AS FGLOGOOCCURRENCETYPE, P.TMSTART, P.TMFINISH, P.CDUSERSTART, ADU.IDUSER AS IDUSERSTART, ADU.NMUSER AS NMUSERSTART, P.CDFAVORITE, P.FGSLASTATUS, P.CDSLACONTROL, CASE P.FGSTATUS WHEN 1 THEN '#{103131}' WHEN 2 THEN '#{107788}' WHEN 3 THEN '#{104230}' WHEN 4 THEN '#{100667}' WHEN 5 THEN '#{200712}' END AS IDSITUATION, CASE P.FGSLASTATUS WHEN 10 THEN '#{218492}' WHEN 30 THEN '#{218493}' WHEN 40 THEN '#{218494}' END AS IDSLASTATUS, CASE WHEN P.VLTIMEFINISH IS NULL THEN 9999999999 ELSE P.VLTIMEFINISH END AS VLTIMEFINISH, PT.CDACTTYPE, PT.IDACTTYPE, PT.NMACTTYPE, PP.NMACTIVITY AS PROCESSMODEL, (SELECT MAX(IDLEVEL) FROM GNSLACTRLHISTORY WHERE CDSLACONTROL=P.CDSLACONTROL AND FGCURRENT=1) AS IDLEVEL, GREV.IDREVISION, SLACTRL.BNSLAFINISH, GNRS.IDREVISIONSTATUS, GNRS.NMREVISIONSTATUS, GNRS.CDREVISIONSTATUS, GNRS.FGLOGO AS FGLOGOREVISIONSTATUS, GNRUS.VLEVALRESULT, GNR.NMEVALRESULT, GNR.FGSYMBOL, CASE WHEN GNR.NRORDER IS NULL THEN -999999999 ELSE GNR.NRORDER END AS NRORDERPRIORITY, dateadd(minute, P.NRTIMEESTFINISH, P.DTESTIMATEDFINISH) AS DTDEADLINEFIELD, P.NRTIMEESTFINISH AS NRHRDEADLINEFIELD, CAST('VLTIMEFINISH' AS VARCHAR(50)) AS NRDEADLINEFIELD_IMG, CAST('VLTIMEFINISH' AS VARCHAR(50)) AS DEADLINEFIELD_DT, (SELECT TOP 1 1 FROM WFPROCDOCUMENT T_QTD_DOC WHERE T_QTD_DOC.IDPROCESS=P.IDOBJECT) AS QTD_DOC, (SELECT TOP 1 1 FROM WFPROCATTACHMENT T_QTD_ATT WHERE T_QTD_ATT.IDPROCESS=P.IDOBJECT AND T_QTD_ATT.CDUSER IS NOT NULL) AS QTD_ATT, ROW_NUMBER() OVER (ORDER/**/ BY P.IDPROCESS ASC) AS ROW_NUM, CASE WHEN P.FGSTATUS IN (1,2,3,5) THEN (CAST(FLOOR(CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))) AS VARCHAR) + LOWER(' #{108037} ') + CAST(FLOOR((CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24) AS VARCHAR) + LOWER(' #{101173} ') + CAST(FLOOR((((CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24) - FLOOR((CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-(P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + LOWER(' #{101181} ')) WHEN P.FGSTATUS=4 THEN (CAST(FLOOR(CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))) AS VARCHAR) + LOWER(' #{108037} ') + CAST(FLOOR((CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24) AS VARCHAR) + LOWER(' #{101173} ') + CAST(FLOOR((((CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24) - FLOOR((CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8)) - FLOOR(CAST(((P.DTFINISH+' '+P.TMFINISH) - (P.DTSTART+' '+P.TMSTART)) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + LOWER(' #{101181} ')) END AS DURATION_WF, CASE WHEN P.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN P.FGCONCLUDEDSTATUS=1 THEN 1 WHEN P.FGCONCLUDEDSTATUS=2 THEN 3 END) ELSE (CASE WHEN (( P.DTESTIMATEDFINISH > (DATEADD(DAY, COALESCE((SELECT QTDAYS FROM ADMAILTASKEXEC WHERE CDMAILTASKEXEC=(SELECT TASK.CDAHEAD FROM ADMAILTASKREL TASK WHERE TASK.CDMAILTASKREL=(SELECT TBL.CDMAILTASKSETTINGS FROM CONOTIFICATION TBL))),1), CAST(<!%TODAY%> AS DATETIME)))) OR (P.DTESTIMATEDFINISH IS NULL)) THEN 1 WHEN (( P.DTESTIMATEDFINISH=CAST(<!%TODAY%> AS DATETIME) AND P.NRTIMEESTFINISH > 987) OR (P.DTESTIMATEDFINISH > CAST(<!%TODAY%> AS DATETIME))) THEN 2 ELSE 3 END) END AS FGDEADLINE, CASE WHEN P.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN P.FGCONCLUDEDSTATUS=1 THEN '#{100900}' WHEN P.FGCONCLUDEDSTATUS=2 THEN '#{100899}' END) ELSE (CASE WHEN (( P.DTESTIMATEDFINISH > (DATEADD(DAY, COALESCE((SELECT QTDAYS FROM ADMAILTASKEXEC WHERE CDMAILTASKEXEC=(SELECT TASK.CDAHEAD FROM ADMAILTASKREL TASK WHERE TASK.CDMAILTASKREL=(SELECT TBL.CDMAILTASKSETTINGS FROM CONOTIFICATION TBL))),1), CAST(<!%TODAY%> AS DATETIME)))) OR (P.DTESTIMATEDFINISH IS NULL)) THEN '#{100900}' WHEN (( P.DTESTIMATEDFINISH=CAST(<!%TODAY%> AS DATETIME) AND P.NRTIMEESTFINISH > 987) OR (P.DTESTIMATEDFINISH > CAST(<!%TODAY%> AS DATETIME))) THEN '#{201639}' ELSE '#{100899}' END) END AS NMDEADLINE ,P.QTHOURS AS QTHOURS, P.FGDURATIONUNIT AS FGDURATIONUNIT, P.CDPROCESS FROM WFPROCESS P LEFT OUTER JOIN PMACTIVITY PP ON (PP.CDACTIVITY=P.CDPROCESSMODEL) LEFT OUTER JOIN PMACTTYPE PT ON (PT.CDACTTYPE=PP.CDACTTYPE) LEFT OUTER JOIN GNREVISION GREV ON (P.CDREVISION=GREV.CDREVISION) LEFT OUTER JOIN ADUSER ADU ON (ADU.CDUSER=P.CDUSERSTART) LEFT OUTER JOIN GNSLACONTROL SLACTRL ON (P.CDSLACONTROL=SLACTRL.CDSLACONTROL) LEFT OUTER JOIN GNREVISIONSTATUS GNRS ON (P.CDSTATUS=GNRS.CDREVISIONSTATUS) LEFT OUTER JOIN GNEVALRESULTUSED GNRUS ON (GNRUS.CDEVALRESULTUSED=P.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNR ON (GNRUS.CDEVALRESULT=GNR.CDEVALRESULT) INNER JOIN INOCCURRENCE INCID ON (P.IDOBJECT=INCID.IDWORKFLOW) LEFT OUTER JOIN GNGENTYPE GNT ON (INCID.CDOCCURRENCETYPE=GNT.CDGENTYPE) INNER JOIN PBPROBLEM PB ON PB.CDOCCURRENCE=INCID.CDOCCURRENCE INNER JOIN (SELECT DISTINCT Z.IDOBJECT FROM (SELECT P.IDOBJECT FROM WFPROCESS P INNER JOIN (SELECT PERM.USERCD, PERM.IDPROCESS, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WF.FGPERMISSION, WF.IDPROCESS, TM.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADTEAMUSER TM ON WF.CDTEAM=TM.CDTEAM WHERE 1=1 AND WF.FGACCESSTYPE=1 AND TM.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND WF.FGACCESSTYPE=2 AND UDP.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT AND WF.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND WF.FGACCESSTYPE=3 AND UDP.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND WF.FGACCESSTYPE=4 AND UDP.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WF.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF WHERE 1=1 AND WF.FGACCESSTYPE=5 AND WF.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF CROSS JOIN ADUSER US WHERE 1=1 AND WF.FGACCESSTYPE=6 AND US.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, RL.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERROLE RL ON RL.CDROLE=WF.CDROLE WHERE 1=1 AND WF.FGACCESSTYPE=7 AND RL.CDUSER=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WFP.CDUSERSTART AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS WHERE 1=1 AND WF.FGACCESSTYPE=30 AND WFP.CDUSERSTART=10309 AND WF.FGACCESSEXCEPTION IS NULL UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDLEADER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND WF.FGACCESSTYPE=31 AND US.CDLEADER=10309 AND WF.FGACCESSEXCEPTION IS NULL) PERM INNER JOIN WFPROCSECURITYCTRL GNASSOC ON GNASSOC.CDACCESSLIST=PERM.CDACCESSLIST AND GNASSOC.IDPROCESS=PERM.IDPROCESS WHERE 1=1 AND GNASSOC.CDACCESSROLEFIELD=501 GROUP BY PERM.USERCD, PERM.IDPROCESS) PERMISSION ON PERMISSION.IDPROCESS=P.IDOBJECT INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=P.IDOBJECT WHERE 1=1 AND PERMISSION.FGPERMISSION=1 AND P.FGSTATUS <= 5 AND (P.FGMODELWFSECURITY IS NULL OR P.FGMODELWFSECURITY=0) AND INCID.FGOCCURRENCETYPE=2 UNION ALL SELECT T.IDOBJECT FROM (SELECT PERM.IDOBJECT, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM1.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADTEAMUSER TM ON PM.CDTEAM=TM.CDTEAM WHERE 1=1 AND PM.FGACCESSTYPE=1 AND TM.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND PM.FGACCESSTYPE=2 AND UDP.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT AND PM.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=3 AND UDP.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=4 AND UDP.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM WHERE 1=1 AND PM.FGACCESSTYPE=5 AND PM.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.FGACCESSTYPE=6 AND US.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERROLE RL ON RL.CDROLE=PM.CDROLE WHERE 1=1 AND PM.FGACCESSTYPE=7 AND RL.CDUSER=10309) PERM1 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM1.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM2.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PMA.CDCREATEDBY AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE WHERE 1=1 AND PM.FGACCESSTYPE=8 AND PMA.CDCREATEDBY=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT WHERE 1=1 AND PM.FGACCESSTYPE=9 AND DEP2.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT AND DEP2.CDPOSITION=DEP1.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=10 AND DEP2.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDPOSITION=DEP1.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=11 AND DEP2.CDUSER=10309 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSER US ON US.CDUSER=PMA.CDCREATEDBY WHERE 1=1 AND PM.FGACCESSTYPE=12 AND US.CDLEADER=10309) PERM2 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM2.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PERM3.IDOBJECT, PMA.FGUSETYPEACCESS, PERM3.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, WFP.CDUSERSTART AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND PM.FGACCESSTYPE=30 AND WFP.CDUSERSTART=10309 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND PM.FGACCESSTYPE=31 AND US.CDLEADER=10309 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1) PERM3 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM3.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM3.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM3.CDACTTYPE=PMA.CDACTTYPE WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND PMA.FGUSETYPEACCESS=1) PERM WHERE 1=1 GROUP BY PERM.IDOBJECT) T INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=T.IDOBJECT WHERE 1=1 AND T.FGPERMISSION=1 AND INCID.FGOCCURRENCETYPE=2 UNION ALL SELECT T.IDOBJECT FROM (SELECT MIN(PERM99.FGPERMISSION) AS FGPERMISSION, PERM99.IDOBJECT FROM (SELECT WFP.IDOBJECT, PERM1.FGPERMISSION FROM (SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADTEAMUSER TM ON PP.CDTEAM=TM.CDTEAM WHERE 1=1 AND PP.FGACCESSTYPE=1 AND TM.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND PP.FGACCESSTYPE=2 AND UDP.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT AND PP.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PP.FGACCESSTYPE=3 AND UDP.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PP.FGACCESSTYPE=4 AND UDP.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, PP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP WHERE 1=1 AND PP.FGACCESSTYPE=5 AND PP.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, US.CDUSER AS USERCD FROM PMPROCACCESSLIST PP CROSS JOIN ADUSER US WHERE 1=1 AND PP.FGACCESSTYPE=6 AND US.CDUSER=10309 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERROLE RL ON RL.CDROLE=PP.CDROLE WHERE 1=1 AND PP.FGACCESSTYPE=7 AND RL.CDUSER=10309) PERM1 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDPROC=GNASSOC.CDPROC INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PERM1.CDPROC WHERE 1=1 AND GNCTRL.CDRELATEDFIELD=501 AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL) AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PERM2.IDOBJECT, PERM2.FGPERMISSION FROM (SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, WFP.CDUSERSTART AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC WHERE 1=1 AND PP.FGACCESSTYPE=30 AND WFP.CDUSERSTART=10309 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, US.CDLEADER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND PP.FGACCESSTYPE=31 AND US.CDLEADER=10309 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5) PERM2 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDPROC=GNASSOC.CDPROC INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY WHERE 1=1 AND GNCTRL.CDRELATEDFIELD=501 AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL)) PERM99 WHERE 1=1 GROUP BY PERM99.IDOBJECT) T INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=T.IDOBJECT WHERE 1=1 AND T.FGPERMISSION=1 AND INCID.FGOCCURRENCETYPE=2 UNION ALL SELECT WFP.IDOBJECT FROM WFPROCESS WFP INNER JOIN WFPROCSECURITYLIST WFLIST ON WFP.IDOBJECT=WFLIST.IDPROCESS INNER JOIN WFPROCSECURITYCTRL WFCTRL ON WFLIST.CDACCESSLIST=WFCTRL.CDACCESSLIST AND WFLIST.IDPROCESS=WFCTRL.IDPROCESS INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=WFP.IDOBJECT WHERE WFCTRL.CDACCESSROLEFIELD=501 AND WFLIST.CDUSER=10309 AND WFLIST.FGACCESSTYPE=5 AND WFLIST.FGACCESSEXCEPTION=1 AND WFLIST.FGPERMISSION=1 AND WFP.FGSTATUS <= 5 AND INCID.FGOCCURRENCETYPE=2) Z WHERE 1=1) MYPERM ON (P.IDOBJECT=MYPERM.IDOBJECT) LEFT OUTER JOIN (SELECT DYNua060.*, GNASSOCFORMREG.CDASSOC FROM GNASSOCFORMREG INNER JOIN DYNua060 ON (DYNua060.OID=GNASSOCFORMREG.OIDENTITYREG AND GNASSOCFORMREG.OIDENTITYMODEL='ff8080816b97fb8c016bdbe2254e2290')) ENT01 ON (ENT01.CDASSOC=P.CDASSOCREG) LEFT OUTER JOIN (SELECT DYNua062.*, GNASSOCFORMREG.CDASSOC FROM GNASSOCFORMREG INNER JOIN DYNua060 ON (DYNua060.OID=GNASSOCFORMREG.OIDENTITYREG AND GNASSOCFORMREG.OIDENTITYMODEL='ff8080816b97fb8c016bdbe2254e2290') INNER JOIN DYNua062 ON (DYNua060.OIDABCPDUHLYO05TNO=DYNua062.OID)) ENT01REF01 ON (ENT01REF01.CDASSOC=P.CDASSOCREG) LEFT OUTER JOIN (SELECT DYNua064.*, GNASSOCFORMREG.CDASSOC FROM GNASSOCFORMREG INNER JOIN DYNua060 ON (DYNua060.OID=GNASSOCFORMREG.OIDENTITYREG AND GNASSOCFORMREG.OIDENTITYMODEL='ff8080816b97fb8c016bdbe2254e2290') INNER JOIN DYNua064 ON (DYNua060.OIDABC5DPJ5UZQEJ7Z=DYNua064.OID)) ENT01REF02 ON (ENT01REF02.CDASSOC=P.CDASSOCREG) LEFT OUTER JOIN (SELECT DYNua065.*, GNASSOCFORMREG.CDASSOC FROM GNASSOCFORMREG INNER JOIN DYNua060 ON (DYNua060.OID=GNASSOCFORMREG.OIDENTITYREG AND GNASSOCFORMREG.OIDENTITYMODEL='ff8080816b97fb8c016bdbe2254e2290') INNER JOIN DYNua065 ON (DYNua060.OIDABCH7ETPYIH2KXZ=DYNua065.OID)) ENT01REF03 ON (ENT01REF03.CDASSOC=P.CDASSOCREG) LEFT OUTER JOIN (SELECT DYNua063.*, GNASSOCFORMREG.CDASSOC FROM GNASSOCFORMREG INNER JOIN DYNua060 ON (DYNua060.OID=GNASSOCFORMREG.OIDENTITYREG AND GNASSOCFORMREG.OIDENTITYMODEL='ff8080816b97fb8c016bdbe2254e2290') INNER JOIN DYNua063 ON (DYNua060.OIDABCIEG083GK2BL2=DYNua063.OID)) ENT01REF04 ON (ENT01REF04.CDASSOC=P.CDASSOCREG) WHERE 1=1 AND GNT.cdgentype IN (<!%FUNC(com.softexpert.generic.parameter.InClauseBuilder, R05HRU5UWVBF, Y2RnZW50eXBl, Y2RnZW50eXBlb3duZXI=,, MTc5,)%>) AND P.FGSTATUS <= 5 AND INCID.FGOCCURRENCETYPE=2 AND (GNT.CDTYPEROLE IS NULL OR EXISTS (SELECT NULL FROM (SELECT CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER HAVING MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.CDTYPEROLE=GNT.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=10309 OR 10309=-1)))) TEMPTB0) TEMPTB1