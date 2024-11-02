select cat.idcategory, rev.iddocument, gnrev.idrevision, rev.nmtitle, stag.dtapproval
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc
, case when doc.fgstatus <> 2 then case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end else 'N/A' end Executor
, case when doc.fgstatus <> 2 then stag.dtdeadline else getdate() end dtdeadline, gnrev.dtrevision
, 1 as qtd
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dccategory cat on cat.cdcategory = rev.cdcategory
 left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL
      and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
      and stag.dtapproval is null
where rev.cdcategory in (16, 35, 40)
and ((stag.dtapproval is null and rev.fgcurrent = 1 and doc.fgstatus = 1) or
(rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument)) and 
(stag.dtapproval = (select max(stagx.dtapproval) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION) or stag.dtapproval is null))
