SELECT
				US.OID,
				US.IDLOGIN,
				USR.NMUSER,
				US.CDUSER,
				US.NMLOGINADDRESS,
				US.BNLOGINTIME,
				(US.BNLOGINTIME / 1000) AS DTLOGIN,
				NULL AS BNLOGOUTTIME,
				NULL AS NMDURATIONFORMATTED,
				US.FGACCESSTYPE,
				LK.NMID,
				NULL AS FGLOGOUTMODE,
				NULL AS NMLOGINERROR,
				NULL AS NRINVALIDLOGIN,
				1 AS FGRECORDTYPE,
				US.FGSESSIONTYPE,
                US.NMTOKEN,
				DEP.IDDEPARTMENT,
				DEP.NMDEPARTMENT,
				DEP.CDDEPARTMENT,
				POS.IDPOSITION,
				POS.NMPOSITION,
				POS.CDPOSITION
			FROM SEUSERSESSION US
			LEFT JOIN COLICENSEKEY LK ON US.OIDLICENSEKEY = LK.OID
			LEFT JOIN ADUSERDEPTPOS USPOS ON USPOS.CDUSER = US.CDUSER AND USPOS.FGDEFAULTDEPTPOS = 1
			LEFT JOIN ADDEPARTMENT DEP ON USPOS.CDDEPARTMENT = DEP.CDDEPARTMENT
			LEFT JOIN ADPOSITION POS ON USPOS.CDPOSITION = POS.CDPOSITION
			LEFT JOIN ADALLUSERS USR ON US.CDUSER = USR.CDUSER
            WHERE 1=1 
		 AND US.FGSESSIONTYPE IN(2,5)
 UNION ALL 

			SELECT
				US.OID,
				US.IDLOGIN,
				USR.NMUSER,
				US.CDUSERCODE AS CDUSER,
				US.NMLOGINADDRESS,
				US.BNLOGINTIME,
				(US.BNLOGINTIME / 1000)  AS DTLOGIN,
				US.BNLOGOUTTIME,
				US.NMDURATIONFORMATTED,
				US.FGACCESSTYPE,
				LK.NMID,
				US.FGLOGOUTMODE,
				US.NMLOGOUTREASON AS NMLOGINERROR,
				US.NRINVALIDLOGIN,
				2 AS FGRECORDTYPE,
				US.FGSESSIONTYPE,
                US.NMTOKEN,
				DEP.IDDEPARTMENT,
				DEP.NMDEPARTMENT,
				DEP.CDDEPARTMENT,
				POS.IDPOSITION,
				POS.NMPOSITION,
				POS.CDPOSITION
			FROM SEUSERSESSIONLOG US
			LEFT JOIN COLICENSEKEY LK ON US.OIDLICENSEKEY = LK.OID
			LEFT JOIN ADUSERDEPTPOS USPOS ON USPOS.CDUSER = US.CDUSERCODE AND USPOS.FGDEFAULTDEPTPOS = 1
			LEFT JOIN ADDEPARTMENT DEP ON USPOS.CDDEPARTMENT = DEP.CDDEPARTMENT
			LEFT JOIN ADPOSITION POS ON USPOS.CDPOSITION = POS.CDPOSITION
			LEFT JOIN ADALLUSERS USR ON US.CDUSERCODE = USR.CDUSER
			WHERE 1=1
		 AND US.FGSESSIONTYPE IN(2,5) 
