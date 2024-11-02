select req.IDREQUEST, req.NMREQUEST
, format(req.DTREQUEST,'dd/MM/yyyy') as dtabertura, datepart(yyyy,req.DTREQUEST) as dtabertura_ano, datepart(MM,req.DTREQUEST) as dtabertura_mes
, cast(coalesce((select substring((select ' | '+ docrev.iddocument as [text()] from DCPRINTREQUEST prt
                 inner join dcdocrevision docrev on docrev.cddocument = prt.cddocument and fgcurrent = 1
                 where prt.cdrequest = req.cdrequest
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listadocumentos --listadocumentos--
, replace(replace(rtrim(ltrim((select cast(dsvalue  as varchar(4000)) from GNREQUESTATTRIB where cdrequest = req.cdrequest and cdattribute = 159))), CHAR(10), ' | '), CHAR(13), '') as codigosap
, replace(replace(rtrim(ltrim((select cast(dsvalue  as varchar(4000)) from GNREQUESTATTRIB where cdrequest = req.cdrequest and cdattribute = 160))), CHAR(10), ' | '), CHAR(13), '') as lote
, replace(replace(rtrim(ltrim((select cast(dsvalue  as varchar(4000)) from GNREQUESTATTRIB where cdrequest = req.cdrequest and cdattribute = 161))), CHAR(10), ' | '), CHAR(13), '') as lotecontrole
, (select attvl.nmattribute from GNREQUESTATTRIB gnatt inner join adattribvalue attvl on attvl.cdattribute = gnatt.cdattribute and attvl.cdvalue = gnatt.cdvalue where cdrequest = req.cdrequest and gnatt.cdattribute = 170) as centrotrab
, (select attvl.nmattribute from GNREQUESTATTRIB gnatt inner join adattribvalue attvl on attvl.cdattribute = gnatt.cdattribute and attvl.cdvalue = gnatt.cdvalue where cdrequest = req.cdrequest and gnatt.cdattribute = 169) as versaoemissao
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from SRREQUESTATTRIBMUL gnatt
                 inner join adattribvalue attvl on attvl.cdattribute = gnatt.cdattribute and attvl.cdvalue = gnatt.cdvalue
                 where cdrequest = req.cdrequest and gnatt.cdattribute = 162
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listamotivo --listadocumentos--
--, (select attvl.nmattribute from SRREQUESTATTRIBMUL gnatt inner join adattribvalue attvl on attvl.cdattribute = gnatt.cdattribute and attvl.cdvalue = gnatt.cdvalue where cdrequest = req.cdrequest and gnatt.cdattribute = 162) as motivo
--, docrev.iddocument
, 1 as quantidade
from GNREQUEST req
--inner join DCPRINTREQUEST prt on prt.cdrequest = req.cdrequest
--inner join dcdocrevision docrev on docrev.cddocument = prt.cddocument and fgcurrent = 1
--select * from GNREQUESTATTRIB where cdattribute = 159
where req.CDREQUESTTYPE in (39)
