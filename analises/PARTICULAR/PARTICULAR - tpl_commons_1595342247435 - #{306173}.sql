SELECT  DIHS.*, DIAR.OIDAPIREQUEST, (DIAR.BNRESPONSEDATETIME-DIAR.BNREQUESTDATETIME) AS DURACAO, DATEADD(S, DIAR.BNREQUESTDATETIME/1000, '1970-01-01 00:00:00') - (DATEDIFF(HOUR, GETDATE(), GETUTCDATE()) / 24.00000000000000000) AS BNREQUESTDATETIME, DATEADD(S, DIAR.BNRESPONSEDATETIME/1000, '1970-01-01 00:00:00') - (DATEDIFF(HOUR, GETDATE(), GETUTCDATE()) / 24.00000000000000000) AS BNRESPONSEDATETIME, 1 AS CONT
FROM DIAPIREQUEST DIAR
LEFT JOIN DIHTTPSTATUS DIHS ON DIHS.NRSTATUS=DIAR.NRRESPONSECODE
