SELECT ACTPLAN.FGDEADLINE
  ,(
    CASE ACTPLAN.FGDEADLINE
      WHEN 1
        THEN '#{100900}'
      WHEN 2
        THEN '#{201639}'
      WHEN 3
        THEN '#{100899}'
      ELSE ''
      END
    ) AS NMDEADLINE
  ,ACTPLAN.QTD
  ,ACTPLAN.TYPENM
FROM (
  SELECT CASE 
      WHEN GNACT.FGSTATUS = 2
        THEN CASE 
            WHEN (
                GNACT.DTSTARTPLAN IS NOT NULL
                AND GNACT.DTSTARTPLAN < dateadd(dd, datediff(dd, 0, getDate()), 0)
                )
              OR (
                EXISTS (
                  SELECT VLPARAM
                  FROM ADPARAMS
                  WHERE CDISOSYSTEM = 174
                    AND CDPARAM = 203
                    AND VLPARAM = 1
                  )
                AND GNACT.DTSTARTPLAN = dateadd(dd, datediff(dd, 0, getDate()), 0)
                AND GNACT.QTTIMESTARTPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10))
                )
              THEN 3
            WHEN (
                GNACT.DTSTARTPLAN IS NULL
                OR GNACT.DTSTARTPLAN >= dateadd(dd, datediff(dd, 0, getDate()), 0)
                )
              THEN 1
            END
      WHEN GNACT.FGSTATUS = 3
        THEN CASE 
            WHEN (
                GNACT.DTSTART IS NULL
                AND (
                  (
                    SELECT VLPARAM
                    FROM ADPARAMS
                    WHERE CDISOSYSTEM = 174
                      AND CDPARAM = 102
                    ) = 2
                  )
                )
              THEN CASE 
                  WHEN (GNACT.DTSTARTPLAN < dateadd(dd, datediff(dd, 0, getDate()), 0))
                    OR (
                      EXISTS (
                        SELECT VLPARAM
                        FROM ADPARAMS
                        WHERE CDISOSYSTEM = 174
                          AND CDPARAM = 203
                          AND VLPARAM = 1
                        )
                      AND (GNACT.DTSTARTPLAN = dateadd(dd, datediff(dd, 0, getDate()), 0))
                      AND (GNACT.QTTIMESTARTPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10)))
                      )
                    THEN 3
                  WHEN (GNACT.DTSTARTPLAN > dateadd(dd, datediff(dd, 0, getDate()), 0))
                    THEN 1
                  ELSE 2
                  END
            WHEN (
                GNACT.DTSTART IS NOT NULL
                AND GNACT.DTFINISH IS NULL
                AND (
                  (
                    SELECT VLPARAM
                    FROM ADPARAMS
                    WHERE CDISOSYSTEM = 174
                      AND CDPARAM = 102
                    ) = 2
                  )
                )
              THEN CASE 
                  WHEN (GNACT.DTFINISHPLAN < dateadd(dd, datediff(dd, 0, getDate()), 0))
                    OR (
                      EXISTS (
                        SELECT VLPARAM
                        FROM ADPARAMS
                        WHERE CDISOSYSTEM = 174
                          AND CDPARAM = 203
                          AND VLPARAM = 1
                        )
                      AND (GNACT.DTSTARTPLAN = dateadd(dd, datediff(dd, 0, getDate()), 0))
                      AND (GNACT.QTTIMESTARTPLAN < GNACT.QTTIMESTART)
                      )
                    THEN 3
                  WHEN (GNACT.DTFINISHPLAN > dateadd(dd, datediff(dd, 0, getDate()), 0))
                    THEN 1
                  ELSE 2
                  END
            WHEN (GNACT.DTFINISH IS NOT NULL)
              THEN CASE 
                  WHEN (
                      EXISTS (
                        SELECT 1
                        FROM ADPARAMS
                        WHERE CDISOSYSTEM = 174
                          AND CDPARAM = 205
                          AND VLPARAM = 1
                        )
                      )
                    THEN CASE 
                        WHEN (GNACT.DTFINISHPLAN < dateadd(dd, datediff(dd, 0, getDate()), 0))
                          OR (
                            EXISTS (
                              SELECT VLPARAM
                              FROM ADPARAMS
                              WHERE CDISOSYSTEM = 174
                                AND CDPARAM = 203
                                AND VLPARAM = 1
                              )
                            AND (GNACT.DTFINISHPLAN = dateadd(dd, datediff(dd, 0, getDate()), 0))
                            AND (GNACT.QTTIMEFINISHPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10)))
                            )
                          THEN 3
                        ELSE 1
                        END
                  WHEN (GNACT.DTFINISH <= GNACT.DTFINISHPLAN)
                    THEN 1
                  WHEN (GNACT.DTFINISH > GNACT.DTFINISHPLAN)
                    OR (
                      EXISTS (
                        SELECT VLPARAM
                        FROM ADPARAMS
                        WHERE CDISOSYSTEM = 174
                          AND CDPARAM = 203
                          AND VLPARAM = 1
                        )
                      AND (GNACT.DTFINISHPLAN = GNACT.DTFINISH)
                      AND (GNACT.QTTIMEFINISHPLAN < GNACT.QTTIMEFINISH)
                      )
                    THEN 3
                  END
            WHEN (
                GNACT.DTFINISH IS NULL
                AND (
                  (
                    SELECT VLPARAM
                    FROM ADPARAMS
                    WHERE CDISOSYSTEM = 174
                      AND CDPARAM = 102
                    ) = 1
                  )
                )
              THEN CASE 
                  WHEN (GNACT.DTFINISHPLAN < dateadd(dd, datediff(dd, 0, getDate()), 0))
                    OR (
                      EXISTS (
                        SELECT VLPARAM
                        FROM ADPARAMS
                        WHERE CDISOSYSTEM = 174
                          AND CDPARAM = 203
                          AND VLPARAM = 1
                        )
                      AND (GNACT.DTFINISHPLAN = dateadd(dd, datediff(dd, 0, getDate()), 0))
                      AND (GNACT.QTTIMEFINISHPLAN < CAST((datepart(minute, getdate()) + datepart(hour, getdate()) * 60) AS NUMERIC(10)))
                      )
                    THEN 3
                  WHEN (GNACT.DTFINISHPLAN > dateadd(dd, datediff(dd, 0, getDate()), 0))
                    THEN 1
                  ELSE 2
                  END
            END
      WHEN GNACT.FGSTATUS = 4
        THEN CASE 
            WHEN (GNACT.DTFINISHPLAN < GNACT.DTFINISH)
              OR (
                EXISTS (
                  SELECT VLPARAM
                  FROM ADPARAMS
                  WHERE CDISOSYSTEM = 174
                    AND CDPARAM = 203
                    AND VLPARAM = 1
                  )
                AND (GNACT.DTFINISHPLAN = GNACT.DTFINISH)
                AND (GNACT.QTTIMEFINISHPLAN < GNACT.QTTIMEFINISH)
                )
              THEN 3
            WHEN (
                GNACT.DTSTARTPLAN IS NULL
                OR GNACT.DTFINISH <= GNACT.DTFINISHPLAN
                )
              THEN 1
            ELSE 3
            END
      END AS FGDEADLINE
    ,1 AS QTD
    ,'#{100475}' AS TYPENM
  FROM GNACTIVITY GNACT
  WHERE GNACT.CDISOSYSTEM = 174
    AND GNACT.FGSTATUS IN (2,3,4)
    AND EXISTS (SELECT 1 FROM GNACTIONPLAN WHERE GNACTIONPLAN.CDGENACTIVITY = GNACT.CDGENACTIVITY AND GNACTIONPLAN.FGMODEL = 2)
    AND (
      GNACT.CDUSERACTIVRESP = <!%CDUSER%>
      OR EXISTS (
        SELECT 1
        FROM ADTEAMUSER
        WHERE ADTEAMUSER.CDTEAM = GNACT.CDTEAM
          AND ADTEAMUSER.CDUSER = <!%CDUSER%>
        )
      )
  ) ACTPLAN
