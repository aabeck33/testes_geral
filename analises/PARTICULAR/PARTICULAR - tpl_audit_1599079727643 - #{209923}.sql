SELECT 1 AS QTDE, COUNT(AUTRACK.CDAUDIT) AS CNT, AUTRACK.FGDEADLINE, AUTRACK.NMDEADLINE FROM (SELECT AU.CDAUDIT, CASE WHEN (CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END > (SELECT dbo.SEF_DTEND_WK_DAYS_PERIOD(CONVERT(DATE, GETDATE()), CAST(3 AS INTEGER) + 1 , (SELECT CDCALENDAR FROM GNCALENDAR WHERE FGDEFAULT = 1))) OR CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END IS NULL) THEN 1 WHEN CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END >= CAST(CONVERT(DATE, GETDATE()) AS DATETIME) THEN 2 ELSE 3 END AS FGDEADLINE, CASE WHEN (CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END > (SELECT dbo.SEF_DTEND_WK_DAYS_PERIOD(CONVERT(DATE, GETDATE()), CAST(3 AS INTEGER) + 1 , (SELECT CDCALENDAR FROM GNCALENDAR WHERE FGDEFAULT = 1))) OR CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END IS NULL) THEN '#{100900}' WHEN CASE WHEN AU.FGAUDITSTATUS IN (18, 20, 30, 33, 40, 43, 48, 50) THEN AUST.DTPLANNEDENDDATE WHEN AU.FGAUDITSTATUS IN (25, 36, 46, 53) THEN (SELECT MAX(GNAR.DTDEADLINE) FROM GNAPPROVRESP GNAR WHERE GNAR.CDPROD = AUST.CDPROD AND GNAR.CDAPPROV = AUST.CDAPPROV AND GNAR.FGPEND=1 AND GNAR.CDCYCLE IN (SELECT GNAP.NRLASTCYCLE FROM GNAPPROV GNAP WHERE GNAR.CDPROD = GNAP.CDPROD AND GNAR.CDAPPROV = GNAP.CDAPPROV)) END >= CAST(CONVERT(DATE, GETDATE()) AS DATETIME) THEN '#{201639}' ELSE '#{100899}' END AS NMDEADLINE FROM AUAUDIT AU INNER JOIN AUSCOPECONFIG AUCFG ON (AUCFG.CDSCOPECONFIG = AU.CDSCOPECONFIG) LEFT OUTER JOIN AUAUDITSTEP AUST ON (AU.CDAUDIT = AUST.CDAUDIT AND ((AUST.FGAUDITSTEP = 2 AND AU.FGAUDITSTATUS IN (18, 20, 25)) OR (AUST.FGAUDITSTEP = 3 AND AU.FGAUDITSTATUS IN (30, 33, 36)) OR (AUST.FGAUDITSTEP = 4 AND AU.FGAUDITSTATUS IN (40, 43, 46)) OR (AUST.FGAUDITSTEP = 5 AND AU.FGAUDITSTATUS IN (48, 50, 53)))) INNER JOIN ADTEAM ADTE ON (AU.CDCONTROLTEAM = ADTE.CDTEAM) WHERE 1 = 1 AND AU.FGAUDITSTATUS < 56 AND (AU.CDCONTROLTEAM IN (SELECT DISTINCT(CDTEAM) FROM ADTEAMUSER WHERE CDUSER = <!%CDUSER%>)) AND AU.FGMODEL = 2 AND AU.IDAUDIT IS NOT NULL UNION ALL SELECT AU.CDAUDIT, CASE WHEN PRTA.FGPHASE = 5 AND PRTA.CDTASK <> PRTA.CDBASETASK THEN NULL WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '2' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < PRTA.DTSCHEDULEDEND OR COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) < CONVERT(DATE, GETDATE())) THEN 3 WHEN (COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) = CONVERT(DATE, GETDATE())) THEN 1 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < PRTA.DTSCHEDULEDEND OR COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < CONVERT(DATE, GETDATE())) THEN 3 ELSE 1 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN 3 ELSE 1 END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '2' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) = PRTA.DTSCHEDULEDST) THEN 1 WHEN (CONVERT(DATE, GETDATE()) > PRTA.DTSCHEDULEDST) THEN 3 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (PRTA.DTSCHEDULEDEND <= PRTA.DTREPLEND AND PRTA.DTREPLEND >= CONVERT(DATE, GETDATE())) THEN 1 ELSE 3 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN 1 ELSE 3 END END WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '3' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) OR COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) < CONVERT(DATE, GETDATE())) THEN 3 WHEN (COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) = CONVERT(DATE, GETDATE())) THEN 1 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) OR COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < CONVERT(DATE, GETDATE())) THEN 3 ELSE 1 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN 3 ELSE 1 END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '3' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) = PRTA.DTREPLST) THEN 1 WHEN (CONVERT(DATE, GETDATE()) > PRTA.DTREPLST) THEN 3 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (PRTA.DTREPLEND <= PRTA.DTREPLEND AND PRTA.DTREPLEND >= CONVERT(DATE, GETDATE())) THEN 1 ELSE 3 END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN 1 ELSE 3 END END WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '1' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.FGPHASE = 2 AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) < COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)) THEN NULL WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) <= CONVERT(DATE, GETDATE()) AND COALESCE(PRTA.QTACTPERC, 0) >= 100) THEN 1 WHEN (PRTA.QTACTPERC >= ((dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, CONVERT(DATE, GETDATE())), NULL) * 100) / CASE WHEN (dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)), NULL) = 0) THEN 1 ELSE dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)), NULL) END) OR ((COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) <= CONVERT(DATE, GETDATE()) OR CONVERT(DATE, GETDATE()) = COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)) AND COALESCE(PRTA.QTACTPERC, 0) >= 100)) THEN 1 ELSE 3 END ELSE CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN 3 ELSE 1 END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '1' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.FGPHASE = 2 AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) < PRTA.DTREPLST) THEN 1 WHEN (PRTA.QTACTPERC >= ((dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, CONVERT(DATE, GETDATE())), NULL) * 100) / CASE WHEN (dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, PRTA.DTREPLEND), NULL) = 0) THEN 1 ELSE dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, PRTA.DTREPLEND), NULL) END) OR ((PRTA.DTREPLEND <= CONVERT(DATE, GETDATE()) OR CONVERT(DATE, GETDATE()) = PRTA.DTREPLST) AND COALESCE(PRTA.QTACTPERC, 0) >= 100)) THEN 1 ELSE 3 END ELSE CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN 1 ELSE 3 END END END AS FGDEADLINE, CASE WHEN PRTA.FGPHASE = 5 AND PRTA.CDTASK <> PRTA.CDBASETASK THEN NULL WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '2' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < PRTA.DTSCHEDULEDEND OR COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) < CONVERT(DATE, GETDATE())) THEN '#{100899}' WHEN (COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) = CONVERT(DATE, GETDATE())) THEN '#{100900}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < PRTA.DTSCHEDULEDEND OR COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < CONVERT(DATE, GETDATE())) THEN '#{100899}' ELSE '#{100900}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN '#{100899}' ELSE '#{100900}' END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '2' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) = PRTA.DTSCHEDULEDST) THEN '#{100900}' WHEN (CONVERT(DATE, GETDATE()) > PRTA.DTSCHEDULEDST) THEN '#{100899}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (PRTA.DTSCHEDULEDEND <= PRTA.DTREPLEND AND PRTA.DTREPLEND >= CONVERT(DATE, GETDATE())) THEN '#{100900}' ELSE '#{100899}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN '#{100900}' ELSE '#{100899}' END END WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '3' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) OR COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) < CONVERT(DATE, GETDATE())) THEN '#{100899}' WHEN (COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) = CONVERT(DATE, GETDATE())) THEN '#{100900}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) OR COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) < CONVERT(DATE, GETDATE())) THEN '#{100899}' ELSE '#{100900}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN '#{100899}' ELSE '#{100900}' END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '3' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.DTACTST IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) = PRTA.DTREPLST) THEN '#{100900}' WHEN (CONVERT(DATE, GETDATE()) > PRTA.DTREPLST) THEN '#{100899}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (PRTA.DTREPLEND <= PRTA.DTREPLEND AND PRTA.DTREPLEND >= CONVERT(DATE, GETDATE())) THEN '#{100900}' ELSE '#{100899}' END WHEN (PRTA.DTACTST IS NOT NULL AND PRTA.DTACTEND IS NOT NULL) THEN CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN '#{100900}' ELSE '#{100899}' END END WHEN (AD1.IDPARAM = '1' AND AD2.IDPARAM = '1' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.FGPHASE = 2 AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) < COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)) THEN NULL WHEN (COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND) <= CONVERT(DATE, GETDATE()) AND COALESCE(PRTA.QTACTPERC, 0) >= 100) THEN '#{100900}' WHEN (PRTA.QTACTPERC >= ((dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, CONVERT(DATE, GETDATE())), NULL) * 100) / CASE WHEN (dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)), NULL) = 0) THEN 1 ELSE dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)), CONVERT(DATETIME, COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)), NULL) END) OR ((COALESCE(PRTA.DTPLANST, PRTA.DTREPLST) <= CONVERT(DATE, GETDATE()) OR CONVERT(DATE, GETDATE()) = COALESCE(PRTA.DTPLANST, PRTA.DTREPLST)) AND COALESCE(PRTA.QTACTPERC, 0) >= 100)) THEN '#{100900}' ELSE '#{100899}' END ELSE CASE WHEN (PRTA.DTACTEND > COALESCE(PRTA.DTPLANEND, PRTA.DTREPLEND)) THEN '#{100899}' ELSE '#{100900}' END END WHEN (AD1.IDPARAM = '2' AND AD2.IDPARAM = '1' AND PRTA.FGPHASE NOT IN (6, 7, 1)) THEN CASE WHEN (PRTA.FGPHASE = 2 AND PRTA.DTACTEND IS NULL) THEN CASE WHEN (CONVERT(DATE, GETDATE()) < PRTA.DTREPLST) THEN '#{100900}' WHEN (PRTA.QTACTPERC >= ((dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, CONVERT(DATE, GETDATE())), NULL) * 100) / CASE WHEN (dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, PRTA.DTREPLEND), NULL) = 0) THEN 1 ELSE dbo.SEF_QT_WK_DAYS_PERIOD (CONVERT(DATETIME, PRTA.DTREPLST), CONVERT(DATETIME, PRTA.DTREPLEND), NULL) END) OR ((PRTA.DTREPLEND <= CONVERT(DATE, GETDATE()) OR CONVERT(DATE, GETDATE()) = PRTA.DTREPLST) AND COALESCE(PRTA.QTACTPERC, 0) >= 100)) THEN '#{100900}' ELSE '#{100899}' END ELSE CASE WHEN (PRTA.DTACTEND <= PRTA.DTREPLEND) THEN '#{100900}' ELSE '#{100899}' END END END AS NMDEADLINE FROM PRPRIORITY PRPI, PRTASKTYPE PRTT, PRTASKBROADCAST PRTB, PRTASK PRTA INNER JOIN AUAUDIT AU ON PRTA.CDBASETASK = AU.CDTASK INNER JOIN AUSCOPECONFIG AUCFG ON (AUCFG.CDSCOPECONFIG = AU.CDSCOPECONFIG), ADPARAMS AD1, ADPARAMS AD2 WHERE PRTA.CDTASK = PRTA.CDBASETASK AND PRTA.CDTASKTYPE = PRTT.CDTASKTYPE AND PRTA.CDPRIORITY = PRPI.CDPRIORITY AND PRTA.CDTASK = PRTB.CDTASK AND PRTA.FGTASKTYPE = 1 AND (PRTA.FGCLOSING IS NULL OR PRTA.FGCLOSING <> 1) AND (PRTA.CDTEAMRESP IN (SELECT DISTINCT(CDTEAM) FROM ADTEAMUSER WHERE CDUSER = <!%CDUSER%>) OR PRTA.CDTASKRESP =<!%CDUSER%>) AND ((PRTA.FGPHASE = 2 AND ((PRTA.DTACTST IS NULL) OR (PRTA.DTACTST IS NOT NULL AND PRTA.FGCLOSING IS NULL OR PRTA.FGCLOSING <> 1))) OR PRTA.FGCLOSING = 3 OR (PRTA.FGPHASE = 7 AND PRTA.FGPREVIOUSPHASE = 2) OR (PRTA.FGPHASE = 6 AND PRTA.FGPREVIOUSPHASE = 2)) AND AD1.CDPARAM = 9 AND AD2.CDPARAM = 73 AND AD1.CDISOSYSTEM = 41 AND AD2.CDISOSYSTEM = 41 AND PRTA.FGTASKTYPE = 1) AUTRACK GROUP BY AUTRACK.FGDEADLINE, AUTRACK.NMDEADLINE
