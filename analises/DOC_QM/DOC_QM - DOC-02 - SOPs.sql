select rev.iddocument, rev.NMTITLE, gnrev.idrevision, doc.fgstatus, doc.cddocument, rev.cdrevision, gnrev.dtrevision, gnrev.dtvalidity
, case doc.fgstatus
	when 1 then 'New SOP'
	when 2 then 'Released'
	when 3 then case rev.fgcurrent when 1 then 'Released' else 'Under Revision' end
	when 4 then 'Canceled'
end situation
, case doc.fgstatus
	when 1 then case when ((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE >= getdate()) then 'On Time'
					 when (((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE < getdate()) or stag.DTDEADLINE is null) then 'Past Due'
				else ''
				end
	when 2 then 'Released'
	when 3 then case rev.fgcurrent when 1 then 'Released'
				else
			case when ((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE >= getdate()) then 'On Time'
			when (((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE < getdate()) or stag.DTDEADLINE is null) then 'Past Due'
			else ''
			end end
	when 4 then 'Canceled'
end status
, case when (rev.fgcurrent <> 1 and (doc.fgstatus = 1 or doc.fgstatus = 3) and datediff(dd, stag.DTDEADLINE, getdate()) <= 30) then 'Being Revised'
	when (rev.fgcurrent <> 1 and (((doc.fgstatus = 1 or doc.fgstatus = 3) and datediff(dd, stag.DTDEADLINE, getdate()) > 30) or ((doc.fgstatus = 1 or doc.fgstatus = 3) and stag.DTDEADLINE is null))) then 'Need Action'
	else 'N/A'
end sitpd
, stag.dtdeadline, usr.nmuser
, (select TOP 1 owner.nmuser from GNREVISIONSTAGMEM stag inner join aduser owner on owner.cduser = stag.cduser where stag.FGSTAGE = 1 AND stag.cdrevision = rev.cdrevision) as owner
, case when doc.fgstatus = 1 or doc.fgstatus = 3 then case stag.fgstage
    when 1 then 'Waiting for Edit'
    when 2 then 'Waiting for approval'
    when 3 then 'Waiting for approval'
    when 4 then 'Waiting to be effective'
    else 'N/A'
  end else 'N/A' end statusExec
, 1 as qty
from dcdocrevision rev
inner join dcdocument doc on rev.cddocument = doc.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION
          and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION) AND stag.DTDEADLINE IS not NULL and (stag.FGAPPROVAL <> 1 or stag.FGAPPROVAL is null)
left join aduser usr on usr.cduser = stag.cduser
where rev.cdcategory = 274 and (rev.cdrevision = (select max(rev2.cdrevision) from dcdocrevision rev2 where rev2.cddocument = doc.cddocument)
or doc.fgstatus = 3 and rev.cdrevision = (select max(rev3.cdrevision) from dcdocrevision rev3 inner join gnrevision gnrev1 on gnrev1.cdrevision = rev3.cdrevision where rev3.cddocument = doc.cddocument and gnrev1.dtrevision is not null))
