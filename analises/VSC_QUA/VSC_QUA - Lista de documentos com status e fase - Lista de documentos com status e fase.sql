select cat.idcategory +' - '+ cat.nmcategory as categoria, rev.iddocument, gnrev.idrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Revisão' when 4 then 'Cancelado' when 5 then 'Indexação' end statusdoc
, case when (rev.fgcurrent = 1 and doc.fgstatus not in (1,4)) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' 
       when rev.fgcurrent = 2 then case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev
, (select top 1 case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
   from GNREVISIONSTAGMEM stag where gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and 
         stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION) and 
         ((rev.fgcurrent = 1 and doc.fgstatus = 1) or (rev.fgcurrent = 2 and doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument)))) as fase
, 1 as quantidade
from dcdocrevision rev
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dcdocument doc on rev.cddocument = doc.cddocument
