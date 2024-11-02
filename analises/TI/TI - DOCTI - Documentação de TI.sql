select iddocument, idrevision, nmtitle, fase, desde, executor, iddepartment, status, 1 as qtd
from (
select rev.iddocument, gnrev.idrevision, rev.nmtitle, rev.cdrevision
 , case when (rev.fgcurrent = 1 and doc.fgstatus not in (1,4)) then 'Vigente' when doc.fgstatus = 4 then 'Cancelado' 
   when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' when rev.fgcurrent = 2 then 
   case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision 
   where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev 
 , case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase 
 , stag.NRCYCLE as ciclo, format(stag.dtdeadline,'dd/MM/yyyy') as dtdeadline, stag.qtdeadline 
 , format(dateadd(day, -stag.qtdeadline, stag.dtdeadline),'dd/MM/yyyy') as desde
 , case when stag.dtdeadline > getdate() then 'Em dia' when stag.dtdeadline < getdate() then 'Atrasado' end as status
 , case when stag.CDUSER is null then case when stag.cddepartment is null then case when stag.cdposition is null then case when cdteam is null then 'NA'  
   else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition pos where pos.cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor 
, dep.iddepartment
 from dcdocrevision rev 
 inner join dcdocument doc on doc.cddocument = rev.cddocument 
 inner join dccategory cat on cat.cdcategory = rev.cdcategory
 inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision 
 left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL
      and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
      and stag.dtapproval is null
left join aduserdeptpos rel on rel.cduser = stag.CDUSER and rel.FGDEFAULTDEPTPOS=1
left join addepartment dep on dep.cddepartment = rel.cddepartment
where cat.cdcategory in (170,161) ) sub
where fase is not null and statusrev in ('Em fluxo','Emissão')
