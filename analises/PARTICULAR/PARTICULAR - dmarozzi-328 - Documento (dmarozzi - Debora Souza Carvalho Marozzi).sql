SELECT DR.CDDOCUMENT,CAST (CASE WHEN DC.FGSTATUS=1 THEN '#{103645}' WHEN DC.FGSTATUS=2 THEN '#{104235}' WHEN DC.FGSTATUS=3 THEN '#{104705}' WHEN DC.FGSTATUS=4 THEN '#{104230}' WHEN DC.FGSTATUS=5 THEN '#{200421}' END AS VARCHAR(255)) AS FGSTATUSDOC ,CT.IDCATEGORY,DR.IDDOCUMENT,DR.NMTITLE,GR.IDREVISION,DR.NMAUTHOR,DR.NRHITS,GR.DTVALIDITY,GR.DTREVISION,MONTH(GR.DTREVISION) AS NMREVISION_MONTH, YEAR(GR.DTREVISION) AS NMREVISION_YEAR FROM DCDOCREVISION DR INNER JOIN DCDOCUMENT DC ON DC.CDDOCUMENT=DR.CDDOCUMENT INNER JOIN DCCATEGORY CT ON DR.CDCATEGORY=CT.CDCATEGORY INNER JOIN SEF_DCCATEGORY_CHILDREN(103) CTFILTER ON (CTFILTER.CDCATEGORY=CT.CDCATEGORY) INNER JOIN GNREVISION GR ON GR.CDREVISION=DR.CDREVISION LEFT JOIN GNREVCONFIG GRC ON (CT.CDREVCONFIG=GRC.CDREVCONFIG) INNER JOIN GNELETRONICFILECFG CFG ON (CFG.CDELETRONICFILECFG=CT.CDELETRONICFILECFG) LEFT OUTER JOIN GNFORMCFGTEMP GFFT ON (GFFT.CDELETRONICFILECFG=CFG.CDELETRONICFILECFG) LEFT OUTER JOIN EFFORM EFF ON (GFFT.OIDFORM=EFF.OID) WHERE 1=1 AND DC.FGSTATUS IN (1,2,3,5)AND (EXISTS (SELECT 1 FROM GNUSERPERMTYPEROLE PM WHERE PM.CDUSER IN (<!%CDUSER%>, -1) AND PM.CDPERMISSION=5 AND PM.CDTYPEROLE=CT.CDTYPEROLE AND PM.FGPERMISSIONTYPE=1 /* sub */UNION ALL SELECT 1  WHERE CT.CDTYPEROLE IS NULL)) AND (NOT EXISTS (SELECT 1 FROM GNUSERPERMTYPEROLE PM WHERE PM.CDUSER IN (<!%CDUSER%>, -1) AND PM.CDPERMISSION=5 AND PM.CDTYPEROLE=CT.CDTYPEROLE AND PM.FGPERMISSIONTYPE=2))AND EXISTS (SELECT 1 FROM (SELECT DDOC.CDPERMISSION FROM DCUSERPERMISSIONDOC DDOC WHERE DDOC.CDUSER IN (<!%CDUSER%>, -1) AND DDOC.CDPERMISSION IN (3) AND DDOC.CDDOCUMENT=DC.CDDOCUMENT AND DDOC.FGPERMISSIONTYPE=1 /* sub */UNION ALL SELECT PC.CDPERMISSION FROM DCUSERPERMISSIONCATEG PC WHERE PC.CDUSER IN (<!%CDUSER%>, -1) AND PC.CDPERMISSION IN (3) AND DR.CDDOCUMENT=DC.CDDOCUMENT AND PC.FGPERMISSIONTYPE=1 AND DR.CDCATEGORY=PC.CDCATEGORY AND DC.FGUSECATACCESSROLE=1 /* sub */UNION ALL SELECT SRU.CDPERMISSION FROM DCSECRULECONDDOC SRC INNER JOIN DCSECRULECONDUSER SRU ON SRU.CDCONDITION=SRC.CDCONDITION WHERE Dc.FGUSECATACCESSROLE=1 AND SRU.CDUSER IN (<!%CDUSER%>, -1) AND SRU.CDPERMISSION IN (3) AND SRC.CDDOCUMENT=DC.CDDOCUMENT AND SRU.FGPERMISSIONTYPE=1 GROUP BY SRU.CDPERMISSION, SRC.CDDOCUMENT, SRU.CDUSER, SRU.FGPERMISSIONTYPE /* sub */UNION ALL SELECT 1 WHERE DC.CDCREATEDBY=<!%CDUSER%>) PERM  WHERE NOT EXISTS(SELECT 1 FROM DCUSERPERMISSIONDOC DDOC WHERE DDOC.CDUSER IN (<!%CDUSER%>, -1) AND DDOC.CDPERMISSION=PERM.CDPERMISSION AND DDOC.CDDOCUMENT=DC.CDDOCUMENT AND DDOC.FGPERMISSIONTYPE=2 AND DC.CDCREATEDBY <> <!%CDUSER%> /* sub */UNION ALL SELECT 1 FROM DCUSERPERMISSIONCATEG PC WHERE PC.CDUSER IN (<!%CDUSER%>, -1) AND PC.CDPERMISSION=PERM.CDPERMISSION AND DR.CDDOCUMENT=DC.CDDOCUMENT AND PC.FGPERMISSIONTYPE=2 AND DR.CDCATEGORY=PC.CDCATEGORY AND DC.FGUSECATACCESSROLE=1 AND DC.CDCREATEDBY <> <!%CDUSER%> /* sub */UNION ALL SELECT 1 FROM DCSECRULECONDDOC SRC INNER JOIN DCSECRULECONDUSER SRU ON SRU.CDCONDITION=SRC.CDCONDITION WHERE DC.FGUSECATACCESSROLE=1 AND SRU.CDUSER IN (<!%CDUSER%>, -1) AND SRU.CDPERMISSION=PERM.CDPERMISSION AND SRC.CDDOCUMENT=DC.CDDOCUMENT AND SRU.FGPERMISSIONTYPE=2 AND DC.CDCREATEDBY <> <!%CDUSER%> GROUP BY SRU.CDPERMISSION, SRC.CDDOCUMENT, SRU.CDUSER, SRU.FGPERMISSIONTYPE) /* sub */UNION ALL SELECT 1 WHERE DC.CDCREATEDBY=<!%CDUSER%>) AND DR.FGCURRENT=1
