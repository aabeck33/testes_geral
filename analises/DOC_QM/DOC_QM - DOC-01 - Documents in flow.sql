select iddocument, idrevision, nmtitle, idcategory, fase, dtdeadline, desde, datediff(day, cast(desde as date), cast(getdate() as date)) qtdtime , executor from (
select rev.iddocument, gnrev.idrevision, rev.nmtitle, rev.cdrevision, cat.idcategory
 , case when (rev.fgcurrent = 1 and doc.fgstatus not in (1,4)) then 'Effective' when doc.fgstatus = 4 then 'Canceled' 
   when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Issue' when rev.fgcurrent = 2 then 
   case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision 
   where CDDOCUMENT = rev.cddocument) then 'In Flow' else 'Obsolete' end end statusrev 
 , case stag.FGSTAGE when 1 then 'Draft' when 2 then 'Review' when 3 then 'Approval' when 4 then 'Release' when 5 then 'Publication' when 6 then 'Close' end fase 
 , stag.NRCYCLE as ciclo, stag.dtdeadline, stag.qtdeadline 
 , format(dateadd(day, -stag.qtdeadline, stag.dtdeadline),'MM/dd/yyyy') as desde
 , case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA'  
   else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
 from dcdocrevision rev 
 inner join dcdocument doc on doc.cddocument = rev.cddocument 
 inner join dccategory cat on cat.cdcategory = rev.cdcategory
 inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision 
 left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL
      and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
      and stag.dtapproval is null
where cat.cdcategory in (
select cdcategory from dccategory where cdcategory in (select cdcategory from dccategory where cdcategoryowner = 268) or
cdcategory in (select cdcategory from dccategory where cdcategoryowner in (select cdcategory from dccategory where cdcategoryowner = 268))
)) sub
where fase is not null and statusrev in ('In Flow','Issue')
