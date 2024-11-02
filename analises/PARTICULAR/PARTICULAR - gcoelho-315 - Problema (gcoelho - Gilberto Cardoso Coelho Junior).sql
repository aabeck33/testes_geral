SELECT IDPROCESS,NMPROCESS,QTD_BI,NMUSER,IDSITUATION,NMSTRUCT,NMUSERSTART,NMEVALRESULT,DTEXECUTION,NMEXECUTEDACTION,NMROLE,WF_QTHOURS,NMOCCURRENCETYPE,NMDEADLINE,DURATION_WF_DAY,DURATION_WF_HOUR,DURATION_WF_MIN FROM (SELECT IDPROCESS,NMPROCESS,QTD_BI,NMUSER,IDSITUATION,NMSTRUCT,NMUSERSTART,NMEVALRESULT,DTEXECUTION,NMEXECUTEDACTION,NMROLE,WF_QTHOURS,NMOCCURRENCETYPE,NMDEADLINE,DURATION_WF_DAY,DURATION_WF_HOUR,DURATION_WF_MIN FROM (SELECT P.CDPROCESS, P.IDOBJECT, P.IDPROCESS, P.CDPROCESSMODEL, P.IDPROCESSMODEL, P.NMPROCESSMODEL, P.NMPROCESS, 1 AS QTD_BI, ADU.NMUSER AS NMUSERSTART, GNR.NMEVALRESULT, S.NMSTRUCT, A.NMROLE, S.FGSTATUS, CASE WHEN S.FGSTATUS=1 THEN 'Não iniciada' WHEN S.FGSTATUS=2 THEN 'Habilitada' WHEN S.FGSTATUS=3 THEN 'Executada' WHEN S.FGSTATUS=4 THEN 'Suspensa' WHEN S.FGSTATUS=5 THEN 'Cancelada' WHEN S.FGSTATUS=6 THEN 'Recusada' WHEN S.FGSTATUS=7 THEN 'Retornada' END AS IDSITUATION, RIGHT('0000' + CAST(FLOOR(A.QTHOURS/1440) AS VARCHAR(20)),4) + ' dia(s) ' + RIGHT('00' + CAST(FLOOR((A.QTHOURS-(FLOOR(A.QTHOURS/1440)*1440))/60) AS VARCHAR(20)),2) + ' hora(s) ' + RIGHT('00' + CAST(A.QTHOURS-(FLOOR(A.QTHOURS/60)*60) AS VARCHAR(20)) ,2) + ' minuto(s)' AS WF_QTHOURS, CASE WHEN S.FGSTATUS IN (2,4,5,6,7) THEN (CAST(('2019-04-02 09:58:36' - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,2))) WHEN S.FGSTATUS=3 THEN (CAST(((S.DTEXECUTION+S.TMEXECUTION) - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,2))) END AS DURATION_WF_DAY, CASE WHEN S.FGSTATUS IN (2,4,5,6,7) THEN (CAST(CAST(('2019-04-02 09:58:36' - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,8))*24 AS NUMERIC(18,2))) WHEN S.FGSTATUS=3 THEN (CAST(CAST(((S.DTEXECUTION+S.TMEXECUTION) - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,8))*24 AS NUMERIC(18,2))) END AS DURATION_WF_HOUR, CASE WHEN S.FGSTATUS IN (2,4,5,6,7) THEN (FLOOR(CAST(('2019-04-02 09:58:36' - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,8))*24*60)) WHEN S.FGSTATUS=3 THEN (FLOOR(CAST(((S.DTEXECUTION+S.TMEXECUTION) - (S.DTENABLED+S.TMENABLED)) AS NUMERIC(18,8))*24*60)) END AS DURATION_WF_MIN, CASE WHEN S.FGSTATUS IN (2,4,5,6,7) THEN (CAST(FLOOR(CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8))) AS VARCHAR) + ' dia(s) ' + CAST(FLOOR((CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8))))*24) AS VARCHAR) + ' hora(s) ' + CAST(FLOOR((((CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8))))*24) - FLOOR((CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((GETDATE()-S.DTENABLED) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + ' minuto(s)') WHEN S.FGSTATUS=3 THEN (CAST(FLOOR(CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8))) AS VARCHAR) + ' dia(s) ' + CAST(FLOOR((CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8))))*24) AS VARCHAR) + ' hora(s) ' + CAST(FLOOR((((CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8))))*24) - FLOOR((CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8)) - FLOOR(CAST((S.DTEXECUTION - S.DTENABLED) AS NUMERIC(18,8))))*24))*60) AS VARCHAR) + ' minuto(s)') END AS DURATION_WF, CASE WHEN S.FGTYPE=1 THEN (CASE WHEN (((SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) > CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME)) OR (( SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) IS NULL)) THEN 1 WHEN (((SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT)=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND (SELECT WFPD.NRTIMEESTFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (( SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT)=CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME))) THEN 2 ELSE 3 END) ELSE (CASE WHEN (( S.DTESTIMATEDFINISH > CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME)) OR (S.DTESTIMATEDFINISH IS NULL)) THEN 1 WHEN (( S.DTESTIMATEDFINISH=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND S.NRTIMEESTFINISH >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (S.DTESTIMATEDFINISH=CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME))) THEN 2 ELSE 3 END) END AS FGDEADLINE, CASE WHEN P.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN P.FGCONCLUDEDSTATUS=1 THEN 1 WHEN P.FGCONCLUDEDSTATUS=2 THEN 3 END) ELSE (CASE WHEN (( P.DTESTIMATEDFINISH > CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME)) OR (P.DTESTIMATEDFINISH IS NULL)) THEN 1 WHEN (( P.DTESTIMATEDFINISH=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND P.NRTIMEESTFINISH >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (P.DTESTIMATEDFINISH=CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME))) THEN 2 ELSE 3 END) END AS FGDEADLINE2, CASE WHEN S.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE WHEN S.FGCONCLUDEDSTATUS=1 THEN 'Em dia' WHEN S.FGCONCLUDEDSTATUS=2 THEN 'Em atraso' END) ELSE (CASE WHEN S.FGTYPE=1 THEN (CASE WHEN (((SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) > CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME)) OR (( SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) IS NULL)) THEN 'Em dia' WHEN (((SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT)=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND (SELECT WFPD.NRTIMEESTFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT) >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (( SELECT WFPD.DTESTIMATEDFINISH FROM WFSTRUCT STRUCT INNER JOIN WFSUBPROCESS SUB ON STRUCT.IDOBJECT=SUB.IDOBJECT INNER JOIN WFPROCESS WFPD ON WFPD.IDOBJECT=SUB.IDSUBPROCESS WHERE STRUCT.IDOBJECT=S.IDOBJECT)=CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME))) THEN 'Próximo do vencimento' ELSE 'Em atraso' END) ELSE (CASE WHEN (( S.DTESTIMATEDFINISH > CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME)) OR (S.DTESTIMATEDFINISH IS NULL)) THEN 'Em dia' WHEN (( S.DTESTIMATEDFINISH=CAST( dateadd(dd, datediff(dd,0, getDate()), 0) AS DATETIME) AND S.NRTIMEESTFINISH >= (datepart(minute, getdate()) + datepart(hour, getdate()) * 60)) OR (S.DTESTIMATEDFINISH=CAST((dateadd(dd, datediff(dd,0, getDate()), 0) + 1) AS DATETIME))) THEN 'Próximo do vencimento' ELSE 'Em atraso' END) END) END AS NMDEADLINE, S.DTEXECUTION AS DTEXECUTION, CASE WHEN A.FGACTAUTOEXECUTED=1 THEN 'Sistema' ELSE A.NMUSER END AS NMUSER, A.NMEXECUTEDACTION, GNT.NMGENTYPE AS NMOCCURRENCETYPE FROM WFPROCESS P LEFT OUTER JOIN GNREVISION GREV ON (P.CDREVISION=GREV.CDREVISION) LEFT OUTER JOIN GNSLACONTROL SLACTRL ON (P.CDSLACONTROL=SLACTRL.CDSLACONTROL) LEFT OUTER JOIN ADUSER ADU ON (ADU.CDUSER=P.CDUSERSTART) LEFT OUTER JOIN PMACTIVITY PP ON (PP.CDACTIVITY=P.CDPROCESSMODEL) LEFT OUTER JOIN PMACTTYPE PT ON (PT.CDACTTYPE=PP.CDACTTYPE) LEFT OUTER JOIN GNREVISIONSTATUS GNRS ON (P.CDSTATUS=GNRS.CDREVISIONSTATUS) LEFT OUTER JOIN GNEVALRESULTUSED GNRUS ON (GNRUS.CDEVALRESULTUSED=P.CDEVALRSLTPRIORITY) LEFT OUTER JOIN GNEVALRESULT GNR ON (GNRUS.CDEVALRESULT=GNR.CDEVALRESULT) INNER JOIN INOCCURRENCE INCID ON (P.IDOBJECT=INCID.IDWORKFLOW) LEFT OUTER JOIN GNGENTYPE GNT ON (INCID.CDOCCURRENCETYPE=GNT.CDGENTYPE) INNER JOIN PBPROBLEM PB ON PB.CDOCCURRENCE=INCID.CDOCCURRENCE INNER JOIN PMPROCESS PMP ON (PMP.CDPROC=P.CDPROCESSMODEL) LEFT OUTER JOIN (SELECT DISTINCT Z.IDOBJECT FROM (SELECT P.IDOBJECT FROM WFPROCESS P INNER JOIN (SELECT PERM.USERCD, PERM.IDPROCESS, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WF.FGPERMISSION, WF.IDPROCESS, TM.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADTEAMUSER TM ON WF.CDTEAM=TM.CDTEAM WHERE 1=1 AND WF.FGACCESSTYPE=1 AND TM.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND WF.FGACCESSTYPE=2 AND UDP.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDDEPARTMENT=UDP.CDDEPARTMENT AND WF.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND WF.FGACCESSTYPE=3 AND UDP.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, UDP.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERDEPTPOS UDP ON WF.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND WF.FGACCESSTYPE=4 AND UDP.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WF.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF WHERE 1=1 AND WF.FGACCESSTYPE=5 AND WF.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF CROSS JOIN ADUSER US WHERE 1=1 AND WF.FGACCESSTYPE=6 AND US.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, RL.CDUSER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN ADUSERROLE RL ON RL.CDROLE=WF.CDROLE WHERE 1=1 AND WF.FGACCESSTYPE=7 AND RL.CDUSER=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, WFP.CDUSERSTART AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS WHERE 1=1 AND WF.FGACCESSTYPE=30 AND WFP.CDUSERSTART=5871 UNION ALL SELECT WF.FGPERMISSION, WF.IDPROCESS, US.CDLEADER AS USERCD, WF.CDACCESSLIST FROM WFPROCSECURITYLIST WF INNER JOIN WFPROCESS WFP ON WFP.IDOBJECT=WF.IDPROCESS INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND WF.FGACCESSTYPE=31 AND US.CDLEADER=5871) PERM INNER JOIN WFPROCSECURITYCTRL GNASSOC ON GNASSOC.CDACCESSLIST=PERM.CDACCESSLIST AND GNASSOC.IDPROCESS=PERM.IDPROCESS WHERE 1=1 AND GNASSOC.CDACCESSROLEFIELD=501 GROUP BY PERM.USERCD, PERM.IDPROCESS) PERMISSION ON PERMISSION.IDPROCESS=P.IDOBJECT INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=P.IDOBJECT WHERE 1=1 AND PERMISSION.FGPERMISSION=1 AND P.FGSTATUS <= 5 AND (P.FGMODELWFSECURITY IS NULL OR P.FGMODELWFSECURITY=0) AND INCID.FGOCCURRENCETYPE=2 UNION ALL SELECT T.IDOBJECT FROM (SELECT PERM.IDOBJECT, MIN(PERM.FGPERMISSION) AS FGPERMISSION FROM (SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM1.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADTEAMUSER TM ON PM.CDTEAM=TM.CDTEAM WHERE 1=1 AND PM.FGACCESSTYPE=1 AND TM.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND PM.FGACCESSTYPE=2 AND UDP.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDDEPARTMENT=UDP.CDDEPARTMENT AND PM.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=3 AND UDP.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERDEPTPOS UDP ON PM.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=4 AND UDP.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PM.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM WHERE 1=1 AND PM.FGACCESSTYPE=5 AND PM.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM CROSS JOIN ADUSER US WHERE 1=1 AND PM.FGACCESSTYPE=6 AND US.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN ADUSERROLE RL ON RL.CDROLE=PM.CDROLE WHERE 1=1 AND PM.FGACCESSTYPE=7 AND RL.CDUSER=5871) PERM1 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM1.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT WFP.IDOBJECT, PMA.FGUSETYPEACCESS, PERM2.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, PMA.CDCREATEDBY AS USERCD FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE WHERE 1=1 AND PM.FGACCESSTYPE=8 AND PMA.CDCREATEDBY=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT WHERE 1=1 AND PM.FGACCESSTYPE=9 AND DEP2.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDDEPARTMENT=DEP1.CDDEPARTMENT AND DEP2.CDPOSITION=DEP1.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=10 AND DEP2.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, DEP2.CDUSER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSERDEPTPOS DEP1 ON DEP1.CDUSER=PMA.CDCREATEDBY INNER JOIN ADUSERDEPTPOS DEP2 ON DEP2.CDPOSITION=DEP1.CDPOSITION WHERE 1=1 AND PM.FGACCESSTYPE=11 AND DEP2.CDUSER=5871 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN ADUSER US ON US.CDUSER=PMA.CDCREATEDBY WHERE 1=1 AND PM.FGACCESSTYPE=12 AND US.CDLEADER=5871) PERM2 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM2.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND WFP.FGSTATUS <= 5 AND PMA.FGUSETYPEACCESS=1 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PERM3.IDOBJECT, PMA.FGUSETYPEACCESS, PERM3.FGPERMISSION FROM (SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, WFP.CDUSERSTART AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL WHERE 1=1 AND PM.FGACCESSTYPE=30 AND WFP.CDUSERSTART=5871 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1 UNION ALL SELECT PM.FGPERMISSION, PM.CDACTTYPE, PM.CDACCESSLIST, US.CDLEADER AS USERCD, WFP.IDOBJECT FROM PMACTTYPESECURLIST PM INNER JOIN PMACTIVITY PMA ON PM.CDACTTYPE=PMA.CDACTTYPE INNER JOIN WFPROCESS WFP ON PMA.CDACTIVITY=WFP.CDPROCESSMODEL INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND PM.FGACCESSTYPE=31 AND US.CDLEADER=5871 AND WFP.FGSTATUS <= 5 AND WFP.FGMODELWFSECURITY=1) PERM3 INNER JOIN PMACTTYPESECURCTRL GNASSOC ON PERM3.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM3.CDACTTYPE=GNASSOC.CDACTTYPE INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACCESSROLEFIELD GNCTRL_F ON GNCTRL.CDRELATEDFIELD=GNCTRL_F.CDACCESSROLEFIELD INNER JOIN PMACTIVITY PMA ON PERM3.CDACTTYPE=PMA.CDACTTYPE WHERE 1=1 AND GNCTRL_F.CDRELATEDFIELD=501 AND PMA.FGUSETYPEACCESS=1) PERM WHERE 1=1 GROUP BY PERM.IDOBJECT) T INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=T.IDOBJECT WHERE 1=1 AND T.FGPERMISSION=1 AND INCID.FGOCCURRENCETYPE=2 UNION ALL SELECT T.IDOBJECT FROM (SELECT MIN(PERM99.FGPERMISSION) AS FGPERMISSION, PERM99.IDOBJECT FROM (SELECT WFP.IDOBJECT, PERM1.FGPERMISSION FROM (SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, TM.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADTEAMUSER TM ON PP.CDTEAM=TM.CDTEAM WHERE 1=1 AND PP.FGACCESSTYPE=1 AND TM.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT WHERE 1=1 AND PP.FGACCESSTYPE=2 AND UDP.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDDEPARTMENT=UDP.CDDEPARTMENT AND PP.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PP.FGACCESSTYPE=3 AND UDP.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, UDP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERDEPTPOS UDP ON PP.CDPOSITION=UDP.CDPOSITION WHERE 1=1 AND PP.FGACCESSTYPE=4 AND UDP.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, PP.CDUSER AS USERCD FROM PMPROCACCESSLIST PP WHERE 1=1 AND PP.FGACCESSTYPE=5 AND PP.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, US.CDUSER AS USERCD FROM PMPROCACCESSLIST PP CROSS JOIN ADUSER US WHERE 1=1 AND PP.FGACCESSTYPE=6 AND US.CDUSER=5871 UNION ALL SELECT PP.FGPERMISSION, PP.CDPROC, PP.CDACCESSLIST, RL.CDUSER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN ADUSERROLE RL ON RL.CDROLE=PP.CDROLE WHERE 1=1 AND PP.FGACCESSTYPE=7 AND RL.CDUSER=5871) PERM1 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON PERM1.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM1.CDPROC=GNASSOC.CDPROC INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PERM1.CDPROC WHERE 1=1 AND GNCTRL.CDRELATEDFIELD=501 AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL) AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PERM2.IDOBJECT, PERM2.FGPERMISSION FROM (SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, WFP.CDUSERSTART AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC WHERE 1=1 AND PP.FGACCESSTYPE=30 AND WFP.CDUSERSTART=5871 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5 UNION ALL SELECT PP.FGPERMISSION, WFP.IDOBJECT, PP.CDPROC, PP.CDACCESSLIST, US.CDLEADER AS USERCD FROM PMPROCACCESSLIST PP INNER JOIN WFPROCESS WFP ON WFP.CDPROCESSMODEL=PP.CDPROC INNER JOIN ADUSER US ON US.CDUSER=WFP.CDUSERSTART WHERE 1=1 AND PP.FGACCESSTYPE=31 AND US.CDLEADER=5871 AND WFP.FGMODELWFSECURITY=1 AND WFP.FGSTATUS <= 5) PERM2 INNER JOIN PMPROCSECURITYCTRL GNASSOC ON PERM2.CDACCESSLIST=GNASSOC.CDACCESSLIST AND PERM2.CDPROC=GNASSOC.CDPROC INNER JOIN PMACCESSROLEFIELD GNCTRL ON GNASSOC.CDACCESSROLEFIELD=GNCTRL.CDACCESSROLEFIELD INNER JOIN PMACTIVITY OBJ ON GNASSOC.CDPROC=OBJ.CDACTIVITY WHERE 1=1 AND GNCTRL.CDRELATEDFIELD=501 AND (OBJ.FGUSETYPEACCESS=0 OR OBJ.FGUSETYPEACCESS IS NULL)) PERM99 WHERE 1=1 GROUP BY PERM99.IDOBJECT) T INNER JOIN INOCCURRENCE INCID ON INCID.IDWORKFLOW=T.IDOBJECT WHERE 1=1 AND T.FGPERMISSION=1 AND INCID.FGOCCURRENCETYPE=2) Z WHERE 1=1) MYPERM ON (P.IDOBJECT=MYPERM.IDOBJECT) INNER JOIN WFSTRUCT S ON (S.IDPROCESS=P.IDOBJECT) INNER JOIN WFACTIVITY A ON (S.IDOBJECT=A.IDOBJECT) WHERE 1=1 AND P.FGSTATUS IN (1,5) AND P.FGSTATUS <= 5 AND INCID.FGOCCURRENCETYPE=2 AND (GNT.CDTYPEROLE IS NULL OR EXISTS (SELECT 1 FROM (SELECT MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE) AS FGACCESSLIST, CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM, ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.FGACCESSLIST=1 AND CHKPERMTYPEROLE.CDTYPEROLE=GNT.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=5871 OR 5871=-1))) AND (MYPERM.IDOBJECT IS NOT NULL)) TEMPTB0) TEMPTB1
