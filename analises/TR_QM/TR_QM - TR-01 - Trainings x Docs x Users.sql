select tr.IDTRAIN, rev.iddocument, gnrev.idrevision, usr.idlogin, usr.nmuser, dep.nmdepartment, pos.nmposition
, (select gn.idrevision from gnrevision gn where gn.cdrevision = (select max(dc.cdrevision) from dcdocrevision dc where dc.cddocument = rev.cddocument)) as reveffective
, 1 as qtd
from trtraining tr
inner join DCDOCTRAIN tdoc on tr.cdtrain = tdoc.cdtrain
inner join gnrevision gnrev on gnrev.cdrevision = tdoc.cdrevision
inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision
inner join trtrainuser trusr on trusr.cdtrain = tr.cdtrain
inner join aduser usr on usr.cduser = trusr.cduser
inner join aduserdeptpos rel on rel.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join adposition pos on pos.cdposition = rel.cdposition
where tr.idtrain like 'UA-%'
