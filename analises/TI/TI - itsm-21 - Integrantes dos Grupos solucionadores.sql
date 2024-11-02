select distinct adr.idrole, usr.idlogin, usr.nmuser, coord.itsm002 as idlogincoord, coord.itsm001 as nmusercoord
from aduser usr
inner join aduserrole adru on adru.cduser = usr.cduser
inner join adrole adr on adr.cdrole = adru.cdrole
inner join DYNitsm017 lgs on lgs.itsm001 = left(adr.idrole, charindex('_', adr.idrole)-1)
inner join DYNitsm016 coord on lgs.OIDABCBSAGZNWY2N0Q = coord.oid
where adr.cdroleowner = 1404
