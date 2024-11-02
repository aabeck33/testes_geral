SELECT GNACTIVITY.NMACTIVITY, GNACTIVITY.IDACTIVITY, ADEC.NMCOMPANY AS NMEXTERNALCOMPANY, ADUSER.IDUSER, COALESCE(ADEU.NMDEPARTMENT, ADDEP.NMDEPARTMENT) AS NMDEPARTMENT, COALESCE(ADEU.NMPOSITION, ADPOS.NMPOSITION) AS NMPOSITION, CASE WHEN SVSURVEY.FGPURPOSESURVEY=1 THEN '#{210771}' ELSE '#{101166}' END AS NMPURPOSESURVEY, CASE GNSURVEYEXECUSER.FGSTATUS WHEN 1 THEN '#{100481}' WHEN 2 THEN '#{300362}' WHEN 3 THEN '#{100651}' WHEN 4 THEN '#{201912}' END AS STATUS, CASE GNACTIVITY.FGSTATUS WHEN 1 THEN '#{100470}' WHEN 2 THEN '#{200135}' WHEN 3 THEN CASE WHEN GNSURVEYEXEC.FGSTATUS=1 THEN '#{100481}' WHEN GNSURVEYEXEC.FGSTATUS=2 THEN '#{209659}' END WHEN 5 THEN '#{108417}' WHEN 6 THEN '#{100481}' WHEN 8 THEN '#{211594}' WHEN 9 THEN '#{211595}' WHEN 10 THEN '#{101006}' WHEN 11 THEN '#{200383}' END AS SURVEY_STATUS , GNSURVEYEXECUSER.DTSTARTEXECUSER , GNSURVEYEXECUSER.DTFINISHEXECUSER, CAST(CAST(GNSURVEYEXECUSER.QTTMTOTALEXECUSER AS NUMERIC(19)) * 60000 AS NUMERIC(19)) AS QTTMTOTALEXECUSER, GNSURVEYEXECUSER.DSREASON, CASE WHEN GNSURVEYEXECUSER.FGAVOID=1 THEN '#{100092}' WHEN GNSURVEYEXECUSER.FGAVOID=2 THEN '#{100093}' ELSE '' END AS NMFGAVOID, CAST( CASE WHEN ADUSER.NMUSER IS NOT NULL THEN ADUSER.NMUSER WHEN ADEU.NMUSER IS NOT NULL THEN ADEU.NMUSER WHEN GNSURVEYEXECUSER.NMPARTICIPANT IS NOT NULL THEN GNSURVEYEXECUSER.NMPARTICIPANT WHEN GNSURVEYEXECUSER.NMPARTICIPANTEMAIL IS NOT NULL THEN GNSURVEYEXECUSER.NMPARTICIPANTEMAIL ELSE '#{210696}' + ' ' + TEMPTB1.NRORDER END AS VARCHAR(4000)) AS NMPARTICIPANT, CAST( CASE WHEN ADUSER.NMUSER IS NOT NULL THEN '#{100222}' WHEN ADEU.NMUSER IS NOT NULL THEN '#{303826}' WHEN GNSURVEYEXECUSER.NMPARTICIPANT IS NOT NULL OR GNSURVEYEXECUSER.NMPARTICIPANTEMAIL IS NOT NULL THEN '#{300578}' ELSE '#{210696}' END AS VARCHAR(4000)) AS NMUSERRESPTYPE, CAST(COALESCE(CAST(ADUSER.DSUSEREMAIL AS VARCHAR (4000)), CAST(ADEU.NMEMAIL AS VARCHAR (4000)), CAST(GNSURVEYEXECUSER.NMPARTICIPANTEMAIL AS VARCHAR (4000))) AS VARCHAR(4000)) AS NMEMAIL, GNSURVEYEXECUSER.VLNOTE, 1 AS NRONE, CASE WHEN GNGENTYPE.IDGENTYPE IS NOT NULL THEN CAST(GNGENTYPE.IDGENTYPE + ' - ' + GNGENTYPE.NMGENTYPE AS VARCHAR(350)) ELSE NULL END AS IDNMSURVEYTYPE,  CASE SVSURVEY.FGLANGUAGE WHEN 1 THEN CAST('#{215202}' AS VARCHAR(50)) WHEN 2 THEN CAST('#{215206}' AS VARCHAR(50)) WHEN 3 THEN CAST('#{215204}' AS VARCHAR(50)) WHEN 4 THEN CAST('#{215205}' AS VARCHAR(50)) WHEN 5 THEN CAST('#{215207}' AS VARCHAR(50)) WHEN 6 THEN CAST('#{215208}' AS VARCHAR(50)) WHEN 7 THEN CAST('#{215209}' AS VARCHAR(50)) WHEN 8 THEN CAST('#{215210}' AS VARCHAR(50)) WHEN 9 THEN CAST('#{215211}' AS VARCHAR(50)) WHEN 10 THEN CAST('#{217207}' AS VARCHAR(50)) WHEN 11 THEN CAST('#{215203}' AS VARCHAR(50)) WHEN 12 THEN CAST('#{215212}' AS VARCHAR(50)) WHEN 13 THEN CAST('#{220249}' AS VARCHAR(50)) WHEN 14 THEN CAST('#{304106}' AS VARCHAR(50)) ELSE NULL END AS NMLANGUAGE FROM SVSURVEYTYPE INNER JOIN GNGENTYPE ON (GNGENTYPE.CDGENTYPE=SVSURVEYTYPE.CDSURVEYTYPE) INNER JOIN GNSURVEY ON (GNSURVEY.CDSURVEYTYPE=SVSURVEYTYPE.CDSURVEYTYPE) INNER JOIN GNSURVEYEXEC ON (GNSURVEYEXEC.CDSURVEY=GNSURVEY.CDSURVEY) INNER JOIN SVSURVEY ON (SVSURVEY.CDSURVEYEXEC=GNSURVEYEXEC.CDSURVEYEXEC) INNER JOIN GNACTIVITY ON (GNACTIVITY.CDGENACTIVITY=SVSURVEY.CDGENACTIVITY) LEFT OUTER JOIN GNSURVEYEXECUSER ON (GNSURVEYEXECUSER.CDSURVEYEXEC=GNSURVEYEXEC.CDSURVEYEXEC) LEFT OUTER JOIN ADEXTERNALUSER ADEU ON (ADEU.CDEXTERNALUSER=GNSURVEYEXECUSER.CDEXTERNALUSER) LEFT OUTER JOIN ADCOMPANY ADEC ON (ADEC.CDCOMPANY=ADEU.CDCOMPANY) LEFT OUTER JOIN ADUSER ON (ADUSER.CDUSER=GNSURVEYEXECUSER.CDUSER) LEFT OUTER JOIN ADDEPARTMENT ADDEP ON (ADDEP.CDDEPARTMENT=GNSURVEYEXECUSER.CDDEPARTMENT) LEFT OUTER JOIN ADPOSITION ADPOS ON (ADPOS.CDPOSITION=GNSURVEYEXECUSER.CDPOSITION) LEFT OUTER JOIN (SELECT GNSU2.CDSURVEYEXEC, GNSU2.CDSURVEYEXECUSER, CAST(ROW_NUMBER() OVER (PARTITION BY GNSU2.CDSURVEYEXEC ORDER BY GNSU2.CDSURVEYEXECUSER) AS VARCHAR(255)) AS NRORDER FROM GNSURVEYEXECUSER GNSU2 WHERE GNSU2.CDUSER IS NULL AND GNSU2.NMPARTICIPANT IS NULL) TEMPTB1 ON (TEMPTB1.CDSURVEYEXECUSER=GNSURVEYEXECUSER.CDSURVEYEXECUSER) WHERE GNSURVEY.FGENABLED=1 AND GNSURVEY.CDSURVEY IN (302)
