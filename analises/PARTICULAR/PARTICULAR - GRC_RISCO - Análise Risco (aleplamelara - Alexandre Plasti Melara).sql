SELECT
        RIRISKANALYSISTEMP.VLCRITVALUESEVREAL,
        RIRISKANALYSISTEMP.VLCRITVALUEPROBREAL,
        GNEVALRESULT.CDEVAL AS GER_CDEVAL,
        GNEVALRESULT.NMEVALRESULT,
        RISKANA.CDASSOCRISKANA,
        RISKANA.CDASSOCRISKANA AS CDASSOCANA,
        RISKANA.CDASSOC,
        RISKANA.CDRISKANABASELINK,
        RISKANA.FGRISKANAPARENT,
        RISKANA.FGRISKASSOCTYPE,
        RIRISKANA.CDRISKANALYSIS,
        RIRISKANA.IDRISKANALYSIS + ' - ' + RIR.NMRISK AS RISK,
        RIRISKANA.CDRISKRESP,
        RIRISKANA.CDRISKTEAM,
        RIRISKANA.CDASSOC AS CDASSOCANALYSIS,
        RIRISKANA.DTNEXTEVAL,
        RIRISKANA.VLTOTAL,
        RIRISKANA.CDEVAL,
        RIRISKANA.VLEXPECTED,
        RIRISKANA.IDRISKANALYSIS,
        RIRISKANA.DSRISKANALYSIS,
        RIRISKANA.CDTOOLSANALISYS,
        RIRISKANA.CDMEASUNITY,
        RIRISKANA.VLLOSSTOTAL,
        RIRISKANA.VLRECOVERED,
        RIRISKANA.VLEVENTLOSSTOTAL,
        RIRISKANA.VLAPPETITE,
        RIRISKANA.VLTOLERANCE,
        RIR.CDASSOC AS CDASSOCRISK,
        RIR.FGENABLED,
        RIR.FGVALUE,
        RIR.CDRISK,
        RIR.IDRISK AS ID,
        RIR.NMRISK,
        RIR.CDRISKTYPE,
        RIR.FGSYMBOL,
        RIR.DSRISK,
        RP.CDPLAN,
        RP.CDREVISION,
        RP.IDPLAN,
        RP.NMPLAN,
        RP.IDPLAN + ' - ' + RP.NMPLAN AS PLANN,
        RP.CDBUSINESSUNIT,
        RP.CDISOSYSTEM,
        RP.CDASSOC AS CDASSOCPLAN,
        RP.FGDEFAULT,
        RP.FGTEMPLATE,
        RP.CDRISKRESIDEVAL,
        RP.CDTEMPLATEREV,
        GNGT.CDGENTYPE,
        GNGT.NMGENTYPE AS NMTYPE,
        GNGT.IDGENTYPE + ' - ' + GNGT.NMGENTYPE AS TYPE,
        GNR.FGSTATUS AS FGREVISION,
        GNR.IDREVISION,
        GGTP.CDISOSYSTEM AS CDPROD,
        ADM.IDMEASUNITY,
        (CASE                                                                  
            WHEN RIRISKANA.CDMEASUNITY IS NOT NULL THEN ADM.IDMEASUNITY + ' - ' + ADM.NMMEASUNITY                                                                  
            ELSE NULL                                              
        END) AS MEASUNITY,
        ADC.IDDEPARTMENT + ' - ' + ADC.NMDEPARTMENT AS NMBUSINESSUNIT,
        ADU.IDUSER,
        ADU.NMUSER,
        ADT.IDTEAM,
        ADT.NMTEAM,
        RIRISKANAE.CDRISKANAEVAL,
        RIRISKANAE.CDASSOC AS CDASSOCRISKANAEVAL,
        RIRISKANAE.IDPERIOD,
        RIRISKANAE.DTEVAL,
        RIRISKANAE.FGCURRENT,
        RIRISKANAE.CDEVALRESULTREAL,
        RIRISKANAE.CDEVALRESULTPOT,
        RIRISKANAE.CDEVALRESULTRESID,
        (CASE                                                                  
            WHEN RIRISKANAE.FGSIGNIFICANT IS NULL THEN 2                                                                  
            ELSE RIRISKANAE.FGSIGNIFICANT                                              
        END) AS FGSIGNIFICANT,
        GNE.IDEVAL + ' - ' + GNE.NMEVAL AS NMEVAL,
        GNE.FGTYPE AS FGEVALTYPE,
        GERU_IN.VLEVALRESULT AS VLEVALRESULTREAL,
        GER_IN.NMEVALRESULT AS NMEVALRESULT_REAL,
        GER_IN.IDCOLOR AS IDCOLOR_REAL,
        GERU_POT.VLEVALRESULT AS VLEVALRESULTPOT,
        GER_POT.NMEVALRESULT AS NMEVALRESULT_POT,
        GER_POT.IDCOLOR AS IDCOLOR_POT,
        GERU_RES.VLEVALRESULT AS VLEVALRESULTRESID,
        GER_RESID.NMEVALRESULT AS NMEVALRESULT_RESID,
        GER_RESID.IDCOLOR AS IDCOLOR_RESID,
        ('{"fground":"2","qtdecimal":"2"}') AS FGROUND_QTDECIMAL_JSON,
        (SELECT
            MIN(NRORDER)                                              
        FROM
            RIPLANITEMORDER                                              
        WHERE
            CDPLAN=RISKANA.CDPLAN                                                                  
            AND CDREVISION=RISKANA.CDREVISION                                                                  
            AND CDRISKANALYSIS=RISKANA.CDASSOCRISKANA) AS NRORDER,
        (CASE                                                                  
            WHEN (SELECT
                CDASSOC                                                                  
            FROM
                GNASSOCRIPLAN                                                                  
            WHERE
                CDPLAN=RP.CDPLAN                                                                                      
                AND CDREVISION=RP.CDREVISION) IS NOT NULL THEN (SELECT
                CDASSOC                                                                  
            FROM
                GNASSOCRIPLAN                                                                  
            WHERE
                CDPLAN=RP.CDPLAN                                                                                      
                AND CDREVISION=RP.CDREVISION)                                                                  
            ELSE (SELECT
                CDASSOC                                                                  
            FROM
                RIPLAN                                                                  
            WHERE
                CDPLAN=RP.CDPLAN                                                                                      
                AND CDREVISION=RP.CDREVISION)                                              
        END) AS CDASSOC_PLAN,
        (CASE                                                                  
            WHEN GER_IN.FGREQCONTROL=1 THEN 1                                                                  
            WHEN GER_POT.FGREQCONTROL=1 THEN 1                                                                  
            WHEN GER_RESID.FGREQCONTROL=1 THEN 1                                                                  
            ELSE 2                                              
        END) AS REQCONTROL,
        (CASE                                                                  
            WHEN GER_IN.FGREQTREATMENT=1 THEN 1                                                                  
            WHEN GER_POT.FGREQTREATMENT=1 THEN 1                                                                  
            WHEN GER_RESID.FGREQTREATMENT=1 THEN 1                                                                  
            ELSE 2                                              
        END) AS REQTREAT,
        (SELECT
            MIN(RIRISKANADECTREE.FGRESULT)                                              
        FROM
            RIRISKANADECTREE                                              
        WHERE
            RIRISKANADECTREE.CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS FGCCPRESULT,
        (( SELECT
            COUNT(1)                                              
        FROM
            GNSTRUCT GNS                                              
        INNER JOIN
            RISTRUCTCAUSE RSC                                                                                      
                ON RSC.CDSTRUCT=GNS.CDSTRUCT                                              
        INNER JOIN
            OBCAUSE OBC                                                                                      
                ON OBC.CDCAUSE=RSC.CDCAUSE                                              
        WHERE
            GNS.CDTOOLANALYSIS=RIRISKANA.CDTOOLSANALISYS) + (SELECT
            COUNT(1)                                              
        FROM
            GNSTRUCT GNS                                              
        INNER JOIN
            GNANALISYS GNA                                                                                      
                ON GNA.CDANALISYS=GNS.CDANALISYS                                              
        INNER JOIN
            GNANALISYS GNANEXT                                                                                      
                ON GNANEXT.CDANALISYSEXT=GNA.CDANALISYS                                              
        WHERE
            GNANEXT.CDTOOLSANALISYS=RIRISKANA.CDTOOLSANALISYS)) AS ASSOC_CAUSE,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCCONTROLANA GNACA                                              
        WHERE
            GNACA.CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_CONTROL,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANATREATMENT                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS                                                                  
            AND CDRISKANAEVAL IS NULL) AS ASSOC_TREATMENT,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANATREATMENT                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS                                                                  
            AND CDRISKANAEVAL IS NULL                                                                  
            AND RIRISKANATREATMENT.CDEVALRESULT IS NOT NULL) AS RISK_RESPONSE,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANATREATMENT                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS                                                                  
            AND CDRISKANAEVAL IS NULL                                                                  
            AND RIRISKANATREATMENT.CDACTIONPLAN IS NOT NULL) AS ACTIONPLAN_TREATMENT,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANACONSEQUE                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS ASSOC_CONSEQUENCE,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANABESTPRACT                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS ASSOC_BESTPRACTICE,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANAOBJECTIVE                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS ASSOC_OBJECTIVE,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANASOURCE                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS ASSOC_SOURCE,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCWORKFLOW GNAW                                              
        INNER JOIN
            WFPROCESS WFP                                                                                      
                ON GNAW.IDPROCESS=WFP.IDOBJECT                                              
        WHERE
            WFP.FGSTATUS <= 5                                                                  
            AND WFP.CDPRODAUTOMATION=160                                                                  
            AND GNAW.CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_INCIDENT,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCWORKFLOW GNAW                                              
        INNER JOIN
            WFPROCESS WFP                                                                                      
                ON GNAW.IDPROCESS=WFP.IDOBJECT                                              
        WHERE
            WFP.FGSTATUS <= 5                                                                  
            AND WFP.CDPRODAUTOMATION=202                                                                  
            AND GNAW.CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_PROBLEM,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCWORKFLOW GNAW                                              
        INNER JOIN
            WFPROCESS WFP                                                                                      
                ON GNAW.IDPROCESS=WFP.IDOBJECT                                              
        WHERE
            WFP.FGSTATUS <= 5                                                                  
            AND GNAW.CDASSOC=RIRISKANA.CDASSOC                                                                  
            AND WFP.CDPRODAUTOMATION NOT IN (
                160, 202                                                                 
            )) AS ASSOC_WORKFLOW,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCPROJECT                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_PROJECT,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCMETRIC                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_METRIC,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCACTIONPLAN                                              
        WHERE
            CDASSOC=RIRISKANAE.CDASSOC) AS ASSOC_ACTIONPLAN_EVAL,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCACTIONPLAN                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_ACTIONPLAN,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCDOCUMENT                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_DOCUMENT,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCATTACH                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_ATTACHMENT,
        (SELECT
            COUNT(1)                                              
        FROM
            GNASSOCSCSTRUCT                                              
        WHERE
            CDASSOC=RIRISKANA.CDASSOC) AS ASSOC_STITEM,
        (SELECT
            COUNT(1)                                              
        FROM
            RIRISKANACOMMENT                                              
        WHERE
            CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS) AS ASSOC_COMMENT,
        (CASE                                                                  
            WHEN RIR.FGVALUE=1 THEN '#{203460}'                                                                  
            ELSE '#{200629}'                                              
        END) AS NMRISKCLASSIFIC,
        (CASE                                                                  
            WHEN RIRISKANAE.FGSIGNIFICANT=1 THEN '#{100092}'                                                                  
            ELSE '#{100093}'                                              
        END) AS NMSIGNIFICANT,
        PMAPROC.IDACTIVITY AS IDPROCESS,
        PMAPROC.NMACTIVITY AS NMPROCESS,
        RIRISKANA.CDRISKANABASE,
        (CASE                                                                  
            WHEN RISKANA.FGRISKANAPARENT=1 THEN (SELECT
                IDPLAN + ' - ' + NMPLAN                                                                  
            FROM
                RIPLAN                                                                  
            WHERE
                CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=2 THEN (SELECT
                IDITEM + ' - ' + NMITEM                                                                  
            FROM
                RIPLANITEM RPI                                                                  
            INNER JOIN
                RIITEM RR                                                                                                          
                    ON RR.CDITEM=RPI.CDITEM                                                                  
            WHERE
                RPI.CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT IN (3,
            4) THEN (SELECT
                RRA.IDRISKANALYSIS + ' - ' + RR.NMRISK                                                                  
            FROM
                RIRISKANALYSIS RRA                                                                  
            INNER JOIN
                RIRISK RR                                                                                                          
                    ON RR.CDRISK=RRA.CDRISK                                                                  
            WHERE
                RRA.CDASSOC=RISKANA.CDASSOC                                                                                      
                AND RRA.CDRISKANALYSIS <> RISKANA.CDRISKANALYSIS)                                                                  
            WHEN RISKANA.FGRISKANAPARENT IN (5,
            6) THEN (SELECT
                IDSCMETRIC + ' - ' + NMMETRIC                                                                  
            FROM
                STSCMETRIC                                                                  
            INNER JOIN
                STMETRIC                                                                                                          
                    ON STMETRIC.CDMETRIC=STSCMETRIC.CDMETRIC                                                                  
            WHERE
                STSCMETRIC.CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=7 THEN (SELECT
                IDSCSTRUCTITEM + ' - ' + NMSCOREITEM                                                                  
            FROM
                STSCSTRUCTITEM SST                                                                  
            INNER JOIN
                STSCOREITEM SCI                                                                                                          
                    ON SCI.CDSCOREITEM=SST.CDSCOREITEM                                                                  
            WHERE
                SST.CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=8 THEN (SELECT
                COALESCE(PMAR.IDACTIVITY,
                PMA.IDACTIVITY) + ' - ' + COALESCE(PMAR.NMACTIVITY,
                PMA.NMACTIVITY)                                                                  
            FROM
                PMACTREVISION PMAR                                                                  
            INNER JOIN
                PMACTIVITY PMA                                                                                                          
                    ON PMA.CDACTIVITY=PMAR.CDACTIVITY                                                                  
            WHERE
                PMAR.CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=9 THEN (SELECT
                COALESCE(PMS.IDACTIVITY,
                PMA.IDACTIVITY) + ' - ' + COALESCE(PMS.NMACTIVITY,
                PMA.NMACTIVITY)                                                                  
            FROM
                PMSTRUCT PMS                                                                  
            INNER JOIN
                PMACTIVITY PMA                                                                                                          
                    ON PMA.CDACTIVITY=PMS.CDACTIVITY                                                                  
            INNER JOIN
                PMACTTYPE PMAT                                                                                                          
                    ON PMAT.CDACTTYPE=PMA.CDACTTYPE                                                                                                          
                    AND PMAT.FGTYPE IN (2,
                3)                                                                  
            WHERE
                PMS.CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT IN (10,
            11) THEN (SELECT
                NMIDTASK + ' - ' + NMTASK                                                                  
            FROM
                PRTASK                                                                  
            WHERE
                CDBASETASK=CDTASK                                                                                      
                AND CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=12 THEN (SELECT
                NMIDTASK + ' - ' + NMTASK                                                                  
            FROM
                PRTASK                                                                  
            WHERE
                CDBASETASK <> CDTASK                                                                                      
                AND CDASSOC=RISKANA.CDASSOC)                                                                  
            WHEN RISKANA.FGRISKANAPARENT=13 THEN (SELECT
                IDOBJECT + ' - ' + NMOBJECT                                                                  
            FROM
                OBOBJECT                                                                  
            WHERE
                CDASSOC=RISKANA.CDASSOC)                                                                  
            ELSE NULL                                              
        END) AS NMRISKPARENT                          
    FROM
        GNASSOCRISKANA RISKANA                          
    INNER JOIN
        RIRISKANALYSIS RIRISKANA                                                                  
            ON RIRISKANA.CDRISKANALYSIS=RISKANA.CDRISKANALYSIS                          
    INNER JOIN
        RIRISK RIR                                                                  
            ON RIR.CDRISK=RIRISKANA.CDRISK                          
    INNER JOIN
        RIRISKTYPE RRT                                                                  
            ON RRT.CDRISKTYPE=RIR.CDRISKTYPE                          
    INNER JOIN
        GNGENTYPE GNGT                                                                  
            ON GNGT.CDGENTYPE=RIR.CDRISKTYPE                          
    INNER JOIN
        GNASSOC GNA                                                                  
            ON GNA.CDASSOC=RIRISKANA.CDASSOC                          
    INNER JOIN
        RIPLAN RP                                                                  
            ON RP.CDPLAN=RISKANA.CDPLAN                                                                  
            AND RP.CDREVISION=RISKANA.CDREVISION                                                                  
            AND RP.FGTEMPLATE=2                          
    INNER JOIN
        GNREVISION GNR                                                                  
            ON GNR.CDREVISION=RP.CDREVISION                          
    INNER JOIN
        GNGENTYPE GGTP                                                                  
            ON GGTP.CDGENTYPE=RP.CDGENTYPE                                                                  
            AND GGTP.FGACTIVE=1                                                                  
            AND GGTP.CDISOSYSTEM=215                          
    INNER JOIN
        GNEVAL GNE                                                                  
            ON GNE.CDEVAL=RIRISKANA.CDEVAL                          
    INNER JOIN
        GNREVCONFIG GNRC                                                                  
            ON (
                GNRC.CDREVCONFIG=GGTP.CDREVCONFIG                                                                 
            )                          
    LEFT OUTER JOIN
        ADUSER ADU                                                                  
            ON ADU.CDUSER=RIRISKANA.CDRISKRESP                          
    LEFT OUTER JOIN
        ADTEAM ADT                                                                  
            ON ADT.CDTEAM=RIRISKANA.CDRISKTEAM                          
    LEFT OUTER JOIN
        ADDEPARTMENT ADC                                                                  
            ON ADC.CDDEPARTMENT=RP.CDBUSINESSUNIT                          
    LEFT OUTER JOIN
        ADMEASUNITY ADM                                                                  
            ON ADM.CDMEASUNITY=RIRISKANA.CDMEASUNITY                          
    LEFT OUTER JOIN
        RIRISKANAEVAL RIRISKANAE                                                                  
            ON RIRISKANAE.CDRISKANALYSIS=RIRISKANA.CDRISKANALYSIS                                                                  
            AND RIRISKANAE.FGCURRENT=1                          
    LEFT OUTER JOIN
        GNEVALRESULTUSED GERU_IN                                                                  
            ON GERU_IN.CDEVALRESULTUSED=RIRISKANAE.CDEVALRESULTREAL                          
    LEFT OUTER JOIN
        GNEVALRESULTUSED GERU_POT                                                                  
            ON GERU_POT.CDEVALRESULTUSED=RIRISKANAE.CDEVALRESULTPOT                          
    LEFT OUTER JOIN
        GNEVALRESULTUSED GERU_RES                                                                  
            ON GERU_RES.CDEVALRESULTUSED=RIRISKANAE.CDEVALRESULTRESID                          
    LEFT OUTER JOIN
        GNEVALRESULT GER_IN                                                                  
            ON GERU_IN.CDEVALRESULT=GER_IN.CDEVALRESULT                          
    LEFT OUTER JOIN
        GNEVALRESULT GER_POT                                                                  
            ON GERU_POT.CDEVALRESULT=GER_POT.CDEVALRESULT                          
    LEFT OUTER JOIN
        GNEVALRESULT GER_RESID                                                                  
            ON GERU_RES.CDEVALRESULT=GER_RESID.CDEVALRESULT                          
    LEFT OUTER JOIN
        GNASSOCRIPLAN GNARP                                                                  
            ON GNARP.CDPLAN=RP.CDPLAN                                                                  
            AND GNARP.CDREVISION=RP.CDREVISION                          
    LEFT OUTER JOIN
        PMACTREVISION PMAR                                                                  
            ON PMAR.CDASSOC=GNARP.CDASSOC                          
    LEFT OUTER JOIN
        PMACTIVITY PMAPROC                                                                  
            ON PMAPROC.CDACTIVITY=PMAR.CDACTIVITY                      
    INNER JOIN
        RIRISKANALYSISTEMP                                                     
            ON RIRISKANA.CDRISKANALYSIS = RIRISKANALYSISTEMP.CDRISKANALYSIS                     
    LEFT JOIN
        GNEVALRESULT                                                     
            ON RIRISKANA.CDEVAL = GNEVALRESULT.CDEVAL                         
    WHERE
        1=1                                              
        AND (
            RP.FGCURRENT=1                                                                  
            AND GNR.FGSTATUS=6                                             
        )                                              
        AND RP.FGSTATUS <> 3                                              
        AND (
            RP.FGCURRENT=1                                                                  
            AND GNR.FGSTATUS=6                                             
        )                                              
        AND RP.FGSTATUS <> 3                                              
        AND (
            RP.CDTYPEROLE IS NULL                                                                  
            OR EXISTS (
                SELECT
                    NULL                                                                                      
                FROM
                    (SELECT
                        CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE,
                        CHKUSRPERMTYPEROLE.CDUSER                                                                                                          
                    FROM
                        (SELECT
                            PM.FGPERMISSIONTYPE,
                            PM.CDUSER,
                            PM.CDTYPEROLE                                                                                                                              
                        FROM
                            GNUSERPERMTYPEROLE PM                                                                                                                              
                        WHERE
                            1=1                                                                                                                                                  
                            AND PM.CDUSER <> -1                                                                                                                                                  
                            AND PM.CDPERMISSION=6 /* Nao retirar este comentario */                                                                                                                             
                        UNION
                        ALL SELECT
                            PM.FGPERMISSIONTYPE,
                            US.CDUSER AS CDUSER,
                            PM.CDTYPEROLE                                                                                                                              
                        FROM
                            GNUSERPERMTYPEROLE PM CROSS                                                                                                                              
                        JOIN
                            ADUSER US                                                                                                                              
                        WHERE
                            1=1                                                                                                                                                  
                            AND PM.CDUSER=-1                                                                                                                                                  
                            AND US.FGUSERENABLED=1                                                                                                                                                  
                            AND PM.CDPERMISSION=6                                                                                                         
                    ) CHKUSRPERMTYPEROLE                                                                                      
                GROUP BY
                    CHKUSRPERMTYPEROLE.CDTYPEROLE,
                    CHKUSRPERMTYPEROLE.CDUSER                                                                                      
                HAVING
                    MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE                                                                  
            WHERE
                CHKPERMTYPEROLE.CDTYPEROLE=RP.CDTYPEROLE                                                                                      
                AND (
                    CHKPERMTYPEROLE.CDUSER=20605                                                                                                          
                    OR 20605=-1                                                                                     
                )                                                                 
            )) 
