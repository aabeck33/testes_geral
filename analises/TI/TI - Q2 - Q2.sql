SELECT
    H.OIDVIEW AS viewoid
    ,H.NMVIEW AS viewnm
    ,CASE V.NRTYPEVIEW 
        WHEN 0 THEN 'TABLE' 
        WHEN 1 THEN 'PIVOT_TABLE' 
        WHEN 2 THEN 'COLUMN' 
        WHEN 3 THEN 'BAR' 
        WHEN 4 THEN 'LINE' 
        WHEN 5 THEN 'PIE' 
        WHEN 6 THEN 'AREA' 
        WHEN 7 THEN 'RADAR' 
        WHEN 8 THEN 'PARETO' 
        WHEN 9 THEN 'ANGULAR' 
        WHEN 10 THEN 'LINEAR_HORIZONTAL' 
        WHEN 11 THEN 'SINGLE_NUMBER' END AS viewtype
    ,H.OIDANALYSIS AS analysisoid
    ,H.IDANALYSIS AS analysisid
    ,H.NMANALYSIS AS analysisnm
    ,U.IDLOGIN AS analysisowner
    ,A.NMUSERUPD AS analysismodifiedby
    ,A.DTUPDATE AS analysismodifiedon
	,A.DTINSERT AS analysiscreatedon
    ,CASE WHEN A.FGINACTIVE=1 THEN 'Yes' ELSE 'No' END AS analysisinactive
    ,H.NMDATASOURCE AS analysisdatasource
    ,CASE H.FGMATERIALIZED WHEN 1 THEN 'Yes' ELSE 'No' END AS analysismaterialized
    --MSSQL
    ,CONVERT(DATETIME, CAST(DATEADD(SECOND, (H.BNTIMESTAMP/1000)-10800, '1970-01-01 00:00:00') AS DATE)) AS logdate
    ,DATEADD(SECOND, (H.BNTIMESTAMP/1000)-10800, '1970-01-01 00:00:00') AS logdatetime
    --ORACLE
    --,TO_DATE('01/01/1970','dd/mm/yyyy hh24:mi:ss') + ( ((H.BNTIMESTAMP/1000)-(10800)) / 86400) AS logdatetime 
    --,TO_DATE(TO_CHAR(TO_DATE('01/01/1970','dd/mm/yyyy hh24:mi:ss') + ( ((H.BNTIMESTAMP/1000)-(10800)) / 86400),'dd/mm/yyyy')) AS logdate
    --POSTGRESQL
    --,CAST('1970-01-01 00:00:00' AS timestamp) + (H.BNTIMESTAMP/1000 || ' second')::INTERVAL AS logdatetime
    --,DATE(CAST('1970-01-01 00:00:00' AS timestamp) + (H.BNTIMESTAMP/1000 || ' second')::INTERVAL) AS logdate
    ,H.NMUSER AS logusername
    ,CASE H.FGORIGIN WHEN 0 THEN 'SE Analytics' WHEN 1 THEN 'SE Performance' WHEN 2 THEN 'SE Forms' END AS logorigin
    ,CASE WHEN FGOPERATION=1 THEN 'Materialization' ELSE 'Reading' END AS logtype
    ,CASE WHEN FGERRORTYPE=1 THEN 'Timeout'WHEN FGERRORTYPE=0 THEN 'Error' ELSE 'Success' END AS logstatus
    ,DSERROR AS logerror
    ,H.BNDURATIONSQL AS logdurationquery
    ,H.BNDURATIONJSON AS logdurationjson
    ,H.NRRECORDS AS logrecords
    ,H.TXREQUESTURL AS logrequesturl 
    ,H.TXRESPONSEHASH AS logresponsehash
    ,1 AS quantity
FROM
    BI2DATAPROVIDERHISTORY H 
    LEFT JOIN BI2ANALYSIS A ON (A.OID=H.OIDANALYSIS) 
    LEFT JOIN BI2OLAPVIEW V ON (H.OIDVIEW=V.OID AND H.OIDANALYSIS=V.OIDANALYSIS) 
    LEFT JOIN GNPERMISSION G ON (G.OID=A.OIDPERMISSION) 
    LEFT JOIN ADALLUSERS U ON (G.CDUSEROWNER=U.CDUSER)
