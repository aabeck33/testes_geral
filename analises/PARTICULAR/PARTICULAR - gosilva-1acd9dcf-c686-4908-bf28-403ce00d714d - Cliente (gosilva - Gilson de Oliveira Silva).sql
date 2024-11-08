SELECT GNC.FGENABLED, ADCT.IDCOMPANYTYPE, ADCT.NMCOMPANYTYPE, (ADCT.IDCOMPANYTYPE + ' - ' + ADCT.NMCOMPANYTYPE) AS IDNMCOMPANYTYPE, GNT.IDGENTYPE, GNT.CDGENTYPE, GNT.CDGENTYPEOWNER, (GNT.IDGENTYPE + ' - ' + GNT.NMGENTYPE) AS IDNMGENTYPE, ADC.IDCOMMERCIAL, ADC.NMCOMPANY, ADC.CDCOMPANY, ADCT.CDCOMPANYTYPE, ADCT.FGLOGO, GNT.FGLOGO AS FGLOGOTYPE, GNC.CDCUSTOMERTYPE, GNC.CDASSOC FROM ADCOMPANY ADC INNER JOIN ADCOMPANYTYPE ADCT ON (ADCT.CDCOMPANYTYPE=ADC.CDCOMPANYTYPE) INNER JOIN GNCUSTOMER GNC ON (GNC.CDCUSTOMER=ADC.CDCOMPANY) INNER JOIN GNGENTYPE GNT ON (GNT.CDGENTYPE=GNC.CDCUSTOMERTYPE) WHERE 1=1 AND GNC.FGENABLED=1 AND (( EXISTS (SELECT 1 FROM GNTYPEROLE GNROLE_ALIAS WHERE GNROLE_ALIAS.CDTYPEROLE=ADCT.CDTYPEROLE AND GNROLE_ALIAS.FGTYPE=1)) OR (EXISTS (SELECT 1 FROM GNTYPEPERMISSION GNROLEDEF_ALIAS WHERE GNROLEDEF_ALIAS.CDTYPEROLE=ADCT.CDTYPEROLE AND GNROLEDEF_ALIAS.CDACCESSLIST=1 AND GNROLEDEF_ALIAS.CDUSER=10755)))
