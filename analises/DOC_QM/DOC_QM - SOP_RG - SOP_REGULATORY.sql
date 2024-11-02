select rev.iddocument, rev.NMTITLE, gnrev.DTREVRELEASE, gnrev.idrevision
, case doc.fgstatus when 1 then 'New SOP' when 2 then 'Released' when 3 then 'Under Revision' when 4 then 'Canceled' end situation
, case when ((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE >= getdate()) then 'On Time'
       when (((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE < getdate()) or stag.DTDEADLINE is null) then 'Past Due'
       else ''
end status
, (select cast(dca.dsvalue as varchar(max)) from dcdocumentattrib dca where dca.cdattribute = 694 and dca.cdrevision = rev.cdrevision) as RegAssessment					
, (select atv.nmattribute					
   from dcdocumentattrib dca					
   inner join adattribvalue atv on atv.cdvalue = dca.cdvalue					
   where dca.cdattribute = 391 and dca.cdrevision = rev.cdrevision) as REGUA					
, stag.dtdeadline, usr.nmuser
, 1 as qtd
from dcdocument doc
inner join dcdocrevision rev on rev.cddocument = doc.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION) AND stag.DTDEADLINE IS not NULL and (stag.FGAPPROVAL <> 1 or stag.FGAPPROVAL is null)
left join aduser usr on usr.cduser = stag.cduser
where rev.cdcategory = 274 and rev.cdrevision = (select max(rev2.cdrevision) from dcdocrevision rev2 where rev2.cddocument = doc.cddocument)
