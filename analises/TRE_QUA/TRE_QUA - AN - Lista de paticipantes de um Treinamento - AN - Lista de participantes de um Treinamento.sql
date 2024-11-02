select rev.iddocument,gnrev.idrevision
, (select count(usr.nmuser) from dcdoctrain trd
inner join TRTRAINUSER tu on tu.cdtrain = trd.cdtrain
inner join aduser usr on usr.cduser = tu.cduser
where trd.cdrevision = rev.cdrevision) as treinadas
, (select count(rel.cduser) from DCDOCCOURSE docc
inner join GNCOURSEMAPITEM relc on docc.cdcourse = relc.cdcourse
inner join addeptposition deppos on relc.cdmapping = deppos.cdmapping
inner join aduserdeptpos rel on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment and FGDEFAULTDEPTPOS = 2
where docc.cddocument = rev.cddocument) as total
, case when (select count(rel.cduser) from DCDOCCOURSE docc
inner join GNCOURSEMAPITEM relc on docc.cdcourse = relc.cdcourse
inner join addeptposition deppos on relc.cdmapping = deppos.cdmapping
inner join aduserdeptpos rel on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment and FGDEFAULTDEPTPOS = 2
where docc.cddocument = rev.cddocument) = 0 then -1 else ((select count(usr.nmuser) from dcdoctrain trd
inner join TRTRAINUSER tu on tu.cdtrain = trd.cdtrain
inner join aduser usr on usr.cduser = tu.cduser
where trd.cdrevision = rev.cdrevision) * 100) / (select count(rel.cduser) from DCDOCCOURSE docc
inner join GNCOURSEMAPITEM relc on docc.cdcourse = relc.cdcourse
inner join addeptposition deppos on relc.cdmapping = deppos.cdmapping
inner join aduserdeptpos rel on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment and FGDEFAULTDEPTPOS = 2
where docc.cddocument = rev.cddocument) end as percentagem
, 1 as quantidade
from dcdocrevision rev
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
where cddocument in (select dcou.cddocument from dcdoccourse dcou inner join trcourse trc on trc.cdcourse = dcou.cdcourse where trc.cdcoursetype in (36,37,38,207))
