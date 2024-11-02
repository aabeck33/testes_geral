select adr.idrole, adr.nmrole, usr.idlogin, usr.nmuser, grsc.itsm001, grsc.itsm002
, 1 as quant
from adrole adr
left join DYNitsm017 grs on grs.itsm001 = left(adr.idrole,coalesce(charindex('_',adr.idrole), 1) -1)
left join DYNitsm016 grsc on grsc.oid = grs.OIDABCBSAGZNWY2N0Q
left join aduserrole adru on adru.cdrole = adr.cdrole
left join aduser usr on usr.cduser = adru.cduser
where adr.cdroleowner = 1404
