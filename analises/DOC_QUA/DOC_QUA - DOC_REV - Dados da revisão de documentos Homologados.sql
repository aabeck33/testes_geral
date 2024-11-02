select cat.idcategory, cat.nmcategory, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, stag.dtdeadline, stag.dtapproval,qtdeadline
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dccategory cat on cat.cdcategory = rev.cdcategory
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
where doc.fgstatus in (2) and rev.cdrevision = (select max(revm.cdrevision) from dcdocrevision revm where revm.cddocument = doc.cddocument)
