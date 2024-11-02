select cat.idcategory, rev.iddocument, gnrev.idrevision, rev.nmtitle
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, stag.dtdeadline
, (select FGUSERENABLED from aduser where cduser = stag.cduser) as UsrStatus
, cast( format ( (select dca.vlvalue from dcdocumentattrib dca where dca.cdattribute = 235 and dca.cdrevision = rev.cdrevision) , '#') as varchar) as chamado
, (select atv.nmattribute
   from dcdocumentattrib dca
   inner join adattribvalue atv on atv.cdvalue = dca.cdvalue
   where dca.cdattribute = 216 and dca.cdrevision = rev.cdrevision) as bpx
, cast(coalesce((select substring((select ' | '+ atv.nmattribute as [text()]
                 from dcdocmultiattrib dca
                 inner join adattribvalue atv on atv.cdattribute = dca.cdattribute and atv.cdvalue = dca.cdvalue
                           where dca.cdattribute = 223 and dca.cdrevision = rev.cdrevision
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as processos
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dccategory cat on cat.cdcategory = rev.cdcategory
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
where rev.cdcategory in (161,170, 172) and stag.dtapproval is null and ((rev.fgcurrent = 1 and doc.fgstatus = 1) or
((rev.fgcurrent = 2) and (doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument))))
