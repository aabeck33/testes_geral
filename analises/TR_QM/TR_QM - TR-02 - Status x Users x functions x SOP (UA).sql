select usr.nmuser,usr.idlogin, coalesce((select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1)), 'NA') as areapadrao
, leader.nmuser as nmleader, leader.idlogin as id_leader
, case when CHARINDEX('-', idposition) <> 0 then SUBSTRING(idposition, CHARINDEX('-', idposition)+1, 3) else '' end as department
, case when CHARINDEX('-', idposition) <> 0 then SUBSTRING(idposition, 1, charindex('-',idposition)-1) else '' end as unid
, revc.iddocument, gnrevc.idrevision, revc.iddocument +'-'+ gnrevc.idrevision as POP
, revc.nmtitle
, case when (coalesce((select case when tu1.fgresult = 1 then 'Approved' when tu1.fgresult = 2 then 'Disapproved' end
              from trtraining tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
              left join DCDOCTRAIN trev1 on trev1.cdtrain = tr1.cdtrain
              where tr1.cdcourse = co.cdcourse and ((revc.cdrevision is not null and trev1.cdrevision = revc.cdrevision) or (revc.cdrevision is null and trev1.cdrevision is null)) and
				tr1.fgstatus >= 5 and tr1.FGCANCEL <> 1 and tr1.cdtrain = (select max(tr2.cdtrain) as cdtrain
                                                        from TRTRAINING tr2
                                                        inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr.cduser
                                                        left join DCDOCTRAIN trev2 on trev2.cdtrain = tr2.cdtrain
                                                        where tr2.cdcourse = co.cdcourse and ((revc.cdrevision is not null and trev2.cdrevision = revc.cdrevision) or (revc.cdrevision is null and trev2.cdrevision is null)) and tr2.fgstatus >= 5 and tr2.FGCANCEL <> 1)), 'Note rated') = 'Approved')
       then case when gnrevc.DTREVISION is null then 'Trained - Waiting SOP to be effective' else 'Trained' end
       else case when gnrevc.DTREVISION is not null then case when (getdate() - gnrevc.DTREVISION) <= 30 then 'Waiting Training (Within 60 days)' else 'Pending' end else case when (getdate() - (select max(stag1.dtapproval)
                from dcdocrevision revi
                inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
                inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revc.cddocument) and
                stag1.fgstage = 3 and nrcycle = (select max(stag1.nrcycle)
                from dcdocrevision revi
                inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
                inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revc.cddocument) and stag1.fgstage = 3))) <= 60 then 'Waiting Training - Waiting SOP to be effective' else 'Waiting Training (over than 60 days)' end end
end Situacao
, 1 as quantidade
from aduser usr
inner join aduserdeptpos rel0 on rel0.cduser = usr.cduser and FGDEFAULTDEPTPOS = 2
left join aduser leader on leader.cduser = usr.cdleader
inner join addepartment dep on dep.cddepartment = rel0.cddepartment and dep.cddepartment in (164)
inner join adposition pos on pos.cdposition = rel0.cdposition and pos.fgposenabled = 1 and (pos.idposition like 'UA0010%')
inner join addeptposition deppos on deppos.cdposition = rel0.cdposition and deppos.cddepartment = rel0.cddepartment
inner join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocument doc on doc.cddocument = docc.cddocument and doc.fgstatus <> 4
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.cdrevision in
       (select max(revo.cdrevision)
        from dcdocrevision revo
        where revo.cddocument = revc.cddocument and revo.fgcurrent = case when (
                (select distinct gnrevi.fgstatus
                from dcdocrevision revi
                inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
                inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revo.cddocument)) <> 4 and
                (select distinct gnrevi.fgstatus
                from dcdocrevision revi
                inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
                inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revo.cddocument)) <> 5) then 1 else
                case (select doco.fgstatus from dcdocument doco where doco.cddocument = revo.cddocument)
                when 1 then 1 when 2 then 1 when 4 then 1 else 2 end end
       )
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
inner join trcourse co on co.cdcourse = relc.cdcourse and co.fgenabled = 1 and co.cdcoursetype in (138,146,147,155,156,157,158,159,160,173)
where usr.fguserenabled = 1
and (gnrevc.DTREVISION is not null or (gnrevc.DTREVISION is null and (select min(fgstage) from (
select fgstage,nrcycle,dtdeadline,fgapproval,dtapproval from GNREVISIONSTAGMEM where cdrevision = revc.cdrevision and nrcycle = (select max(stag1.nrcycle)
from dcdocrevision revi
inner join gnrevision gnrevi on gnrevi.cdrevision = revi.cdrevision
inner join GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
where revi.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = revc.cddocument))) _sub
where dtdeadline is not null and fgapproval is null and dtapproval is null) > 3))
