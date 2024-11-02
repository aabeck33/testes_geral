SELECT DR.CDREVISION,CAST (CASE WHEN GR.FGSTATUS=1 THEN 'Elaboração' WHEN GR.FGSTATUS=2 THEN 'Consenso' WHEN GR.FGSTATUS=3 THEN 'Aprovação' WHEN GR.FGSTATUS=4 THEN 'Homologação' WHEN GR.FGSTATUS=5 THEN 'Liberação' WHEN GR.FGSTATUS=6 THEN 'Encerrada' END AS VARCHAR(255)) AS NMSTATUSREV ,CT.IDCATEGORY,DR.IDDOCUMENT,DR.NMTITLE,GR.IDREVISION,DR.NMAUTHOR,GR.DTREVISION FROM DCDOCREVISION DR INNER JOIN DCDOCUMENT DC ON DC.CDDOCUMENT=DR.CDDOCUMENT INNER JOIN DCCATEGORY CT ON DR.CDCATEGORY=CT.CDCATEGORY INNER JOIN GNREVISION GR ON GR.CDREVISION=DR.CDREVISION INNER JOIN DCFILE DE ON DE.CDREVISION=DR.CDREVISION INNER JOIN SEF_DCCATEGORY_CHILDREN(24) CTFILTER ON (CTFILTER.CDCATEGORY=CT.CDCATEGORY) LEFT OUTER JOIN DCDOCUMENTARCHIVAL DA ON DA.CDDOCUMENT=DR.CDDOCUMENT INNER JOIN GNREVCONFIG GNREV ON (GNREV.CDREVCONFIG=CT.CDREVCONFIG) LEFT OUTER JOIN GNREVISIONSTATUS GNST ON (GR.CDREVISIONSTATUS=GNST.CDREVISIONSTATUS) INNER JOIN GNELETRONICFILECFG CFG ON (CFG.CDELETRONICFILECFG=CT.CDELETRONICFILECFG) LEFT OUTER JOIN GNFORMCFGTEMP GFFT ON (GFFT.CDELETRONICFILECFG=CFG.CDELETRONICFILECFG) LEFT OUTER JOIN EFFORM EFF ON (GFFT.OIDFORM=EFF.OID) LEFT JOIN (SELECT MAX(T.FGPERMISSIONTYPE) AS FGPERMISSION, T.CDDOCUMENT FROM/*SUB*/ DCUSERPERMISSION_V T WHERE 1=1 AND T.CDUSER IN (779, -1) AND T.CDPERMISSION=3 GROUP BY T.CDDOCUMENT) Z3 ON DC.CDDOCUMENT=Z3.CDDOCUMENT AND Z3.FGPERMISSION=1 WHERE 1=1 AND DC.FGSTATUS IN (1,2,3) AND GR.CDISOSYSTEM=21 AND GNST.CDREVISIONSTATUS IS NULL AND (GR.FGSTATUS=(1) OR GR.FGSTATUS=(2) OR GR.FGSTATUS=(3) OR GR.FGSTATUS=(4)) AND (CT.CDTYPEROLE IS NULL OR EXISTS (SELECT 1 FROM (SELECT MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE) AS FGACCESSLIST, CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER FROM (SELECT PM.FGPERMISSIONTYPE, PM.CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM WHERE 1=1 AND PM.CDUSER <> -1 AND PM.CDPERMISSION=5 /* Nao retirar este comentario */UNION ALL SELECT PM.FGPERMISSIONTYPE, US.CDUSER AS CDUSER, PM.CDTYPEROLE FROM GNUSERPERMTYPEROLE PM, ADUSER US WHERE 1=1 AND PM.CDUSER=-1 AND US.FGUSERENABLED=1 AND PM.CDPERMISSION=5) CHKUSRPERMTYPEROLE GROUP BY CHKUSRPERMTYPEROLE.CDTYPEROLE, CHKUSRPERMTYPEROLE.CDUSER) CHKPERMTYPEROLE WHERE CHKPERMTYPEROLE.FGACCESSLIST=1 AND CHKPERMTYPEROLE.CDTYPEROLE=CT.CDTYPEROLE AND (CHKPERMTYPEROLE.CDUSER=779 OR 779=-1))) AND ((Z3.CDDOCUMENT IS NOT NULL) OR (DC.CDCREATEDBY=779)) AND CT.FGENABLEREVISION=1
