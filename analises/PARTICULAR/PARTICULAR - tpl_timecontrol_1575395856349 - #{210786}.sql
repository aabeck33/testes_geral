SELECT CASE 
    WHEN ACTACTION.FGDEADLINE = 1
      THEN '#{100900}'
    WHEN ACTACTION.FGDEADLINE = 2
      THEN '#{201639}'
    WHEN ACTACTION.FGDEADLINE = 3
      THEN '#{100899}'
    ELSE NULL
    END AS NMDEADLINE
  ,CASE 
    WHEN ACTACTION.FGACTION = 1
      THEN '#{210804}'
    ELSE '#{210851}'
    END AS NMACTION
  ,ACTACTION.FGACTION
  ,ACTACTION.FGDEADLINE
  ,1 AS QTD
FROM (
  SELECT GNACT.FGACTION
    ,CASE 
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
  FROM (
    SELECT G.CDGENACTIVITY
      ,G.DTSTARTPLAN
      ,G.QTTIMESTARTPLAN
      ,G.DTFINISHPLAN
      ,G.QTTIMEFINISHPLAN
      ,G.DTSTART
      ,G.QTTIMESTART
      ,G.DTFINISH
      ,G.QTTIMEFINISH
      ,G.FGSTATUS
      ,G.CDCALENDAR
      ,1 AS FGACTION
    FROM GNACTIVITY G
    WHERE G.CDISOSYSTEM = 174
      AND G.FGSTATUS IN (2,3,4)
      AND EXISTS (SELECT 1 FROM GNTASK WHERE GNTASK.CDGENACTIVITY = G.CDGENACTIVITY)
      AND (
        G.CDUSERACTIVRESP = <!%CDUSER%>
        OR EXISTS (
          SELECT 1
          FROM ADTEAMUSER
          WHERE ADTEAMUSER.CDTEAM = G.CDTEAM
            AND ADTEAMUSER.CDUSER = <!%CDUSER%>
          )
        )
    
    UNION ALL
    
    SELECT G.CDGENACTIVITY
      ,G.DTSTARTPLAN
      ,G.QTTIMESTARTPLAN
      ,G.DTFINISHPLAN
      ,G.QTTIMEFINISHPLAN
      ,G.DTSTART
      ,G.QTTIMESTART
      ,G.DTFINISH
      ,G.QTTIMEFINISH
      ,G.FGSTATUS
      ,GPLAN.CDCALENDAR
      ,2 AS FGACTION
    FROM GNACTIVITY G
    INNER JOIN GNACTIVITY GPLAN ON GPLAN.CDGENACTIVITY = G.CDACTIVITYOWNER
    WHERE G.CDISOSYSTEM = 174
      AND GPLAN.CDISOSYSTEM = 174
      AND G.FGSTATUS IN (2,3,4)
      AND EXISTS (SELECT 1 FROM GNTASK WHERE GNTASK.CDGENACTIVITY = G.CDGENACTIVITY)
      AND (
        GPLAN.CDUSERACTIVRESP = <!%CDUSER%>
        OR EXISTS (
          SELECT 1
          FROM ADTEAMUSER
          WHERE ADTEAMUSER.CDTEAM = GPLAN.CDTEAM
            AND ADTEAMUSER.CDUSER = <!%CDUSER%>
          )
        )
    ) GNACT
  WHERE 1 = 1
  ) ACTACTION
