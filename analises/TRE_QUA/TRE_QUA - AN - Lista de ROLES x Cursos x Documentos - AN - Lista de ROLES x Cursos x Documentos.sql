select pos.nmposition, co.idcourse
, case relc.fgreq when 1 then 'Requerido' when 2 then 'Desejável' end as Requerido
, revc.iddocument, gnrevc.idrevision, 1 as quantidade
from adposition pos
left join addeptposition deppos on deppos.cdposition = pos.cdposition and deppos.cddepartment in (164)
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join trcourse co on co.cdcourse = relc.cdcourse
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
where pos.cdposition in (select cdposition from aduserdeptpos where FGDEFAULTDEPTPOS = 2)
and (gnrevc.DTREVISION is not null or (gnrevc.DTREVISION is null and (select min(fgstage) from (
select fgstage,nrcycle,dtdeadline,fgapproval,dtapproval from GNREVISIONSTAGMEM where cdrevision = revc.cdrevision and nrcycle = (select max(stag1.nrcycle)
from dcdocrevision revi
inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revc.cddocument))) _sub
where dtdeadline is not null and fgapproval is null and dtapproval is null) > 3))
