SELECT
        DEP.CDDEPARTMENT ,
        ADP.CDMAPPING ,
        DEP.IDDEPARTMENT ,
        DEP.NMDEPARTMENT ,
        POS.CDPOSITION ,
        POS.IDPOSITION ,
        POS.NMPOSITION ,
        '<label class=''x-grid-group-header-label-ct''>' + '<div class=''x-grid-group-header-div-flex-ct''>' + '<div class=''x-grid-group-header-div-flex-1''>' + '<div class=''x-grid-group-header-div-flex-1 x-grid-group-header-div-flex-dir-column''>' + '<div class=''x-grid-group-header-div-label-title-ct''><label class=''x-grid-group-header-label-title''>Área</label></div>' + '<div class=''x-grid-group-header-div-label-title-ct''>' + '<label class=''x-grid-group-header-label-strong-text''>' + DEP.IDDEPARTMENT + ' - ' + DEP.NMDEPARTMENT + '</label>' + '</div>' + '</div>' + '</div>' + '<div class=''x-grid-group-header-div-flex-1 x-grid-group-header-div-flex-padding-left''>' + '<div class=''x-grid-group-header-div-flex-1 x-grid-group-header-div-flex-dir-column''>' + '<div class=''x-grid-group-header-div-label-title-ct''><label class=''x-grid-group-header-label-title''>Função</label></div>' + '<div class=''x-grid-group-header-div-label-title-ct''>' + '<label class=''x-grid-group-header-label-strong-text''>' + POS.IDPOSITION + ' - ' + POS.NMPOSITION + '</label>' + '</div>' + '</div>' + '</div>' + '</div>' + '</label>' AS IDNMDEPTPOSGRID,
        CAST(DEP.IDDEPARTMENT + ' - ' + DEP.NMDEPARTMENT AS VARCHAR(310)) AS IDNMDEPARTMENT,
        CAST(POS.IDPOSITION + ' - ' + POS.NMPOSITION AS VARCHAR(310)) AS IDNMPOSITION,
        CAST(C.IDCOURSE+ ' - ' +C.NMCOURSE AS VARCHAR(310)) AS IDNMCOURSE,
        CAST(GNT.IDGENTYPE+ ' - ' + GNT.NMGENTYPE AS VARCHAR(310)) AS IDNMCOURSETYPE,
        ADP.CDMAPPING  AS QTOPERATORFIELD,
        3  AS FGTYPEMAPPING,
        ROW_NUMBER() OVER(PARTITION 
    BY
        ADP.CDMAPPING 
    ORDER BY
        CM.FGREQ DESC,
        C.IDCOURSE DESC) AS FGSHOWGROUPCOUNT,
        ROW_NUMBER() OVER(PARTITION 
    BY
        ADP.CDMAPPING 
    ORDER BY
        CM.FGREQ ASC,
        C.IDCOURSE ASC) AS FGSHOWGROUP,
        CM.FGREQ,
        GNT.IDGENTYPE AS IDCOURSETYPE,
        GNT.CDGENTYPE AS CDCOURSETYPE,
        C.CDCOURSE,
        C.IDCOURSE,
        C.NMCOURSE,
        C.FGCOURSETYPE,
        CASE 
            WHEN C.FGCOURSETYPE=2 THEN '#{217149}' 
            ELSE '#{102342}' 
        END AS NMCOURSETYPE,
        CASE  
            WHEN CM.FGREQ=1  THEN CAST('#{104003}' AS VARCHAR(255))  
            WHEN CM.FGREQ=2  THEN CAST('#{104189}' AS VARCHAR(255)) 
        END  AS NMFGREQ,
        CAST(DEP.IDDEPARTMENT + ' - ' + DEP.NMDEPARTMENT+ '/' + POS.IDPOSITION + ' - ' + POS.NMPOSITION AS VARCHAR(4000)) AS IDNM 
    FROM
        ADDEPARTMENT DEP 
    INNER JOIN
        ADDEPTPOSITION ADP 
            ON (
                ADP.CDDEPARTMENT=DEP.CDDEPARTMENT
            ) 
    INNER JOIN
        ADPOSITION POS 
            ON (
                POS.CDPOSITION=ADP.CDPOSITION
            ) 
    INNER JOIN
        GNCOURSEMAPITEM CM 
            ON (
                CM.CDMAPPING=ADP.CDMAPPING
            ) 
    INNER JOIN
        TRCOURSE C 
            ON (
                CM.CDCOURSE=C.CDCOURSE
            ) 
    INNER JOIN
        TRCOURSETYPE CT 
            ON (
                C.CDCOURSETYPE=CT.CDCOURSETYPE
            ) 
    INNER JOIN
        GNGENTYPE GNT 
            ON (
                CT.CDCOURSETYPE=GNT.CDGENTYPE
            ) 
    WHERE
        DEP.FGDEPTENABLED=1 
        AND POS.FGPOSENABLED=1 
        AND ADP.CDMAPPING IS NOT NULL
