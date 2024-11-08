select A.IDLOGIN,
	   A.NMUSER,
	   L.NMID,
	   L.NRNUMBEROFUSERS,
	   CASE L.FGPROFILE   
         WHEN 0 THEN 'CONNECTOR'
         WHEN 1 THEN '#{200812}'
         WHEN 2 THEN '#{106698}'
         WHEN 3 THEN '#{106697}'
         WHEN 4 THEN '#{300385}'
		END AS LICENSE_PROFILE,
		CASE L.FGLICENSEUSETYPE
			WHEN 0 THEN '#{103969}'
			WHEN 1 THEN 'TIME_AMOUNT_OF_USE'
			WHEN 2 THEN '#{103964}'
		END AS LICENSE_USETYPE,
	   H.SESSION_LOGIN, 
	   ADP.NMDEPARTMENT,
	   ADO.NMPOSITION,
	   1 as QTD
from (
	select CDUSER,
		   OIDLICENSEKEY,
		   DATEADD(SECOND, (BNLOGINTIME/1000)+'<!%FUNC("com.softexpert.utils.TimeZoneHelper")%>', '1970-01-01 00:00:00') SESSION_LOGIN 
	  from SEUSERSESSION
	  WHERE FGSESSIONTYPE=2
	  AND OIDLICENSEKEY IS NOT NULL) as H
LEFT OUTER JOIN COLICENSEKEY L ON (L.OID=H.OIDLICENSEKEY)
LEFT OUTER JOIN ADUSER A ON (A.CDUSER=H.CDUSER)
LEFT OUTER JOIN ADUSERDEPTPOS ADU on (ADU.CDUSER = A.CDUSER)
LEFT OUTER JOIN ADDEPARTMENT ADP ON (ADU.CDDEPARTMENT=ADP.CDDEPARTMENT)
LEFT OUTER JOIN ADPOSITION ADO ON (ADU.CDPOSITION=ADO.CDPOSITION)
