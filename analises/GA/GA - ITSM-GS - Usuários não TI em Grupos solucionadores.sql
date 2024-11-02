select usr.idlogin, usr.nmuser, adr.idrole, adr.nmrole, dep.nmdepartment
from aduser usr
inner join aduserrole adru on adru.cduser = usr.cduser
inner join adrole adr on adr.cdrole = adru.cdrole
inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
where adr.cdroleowner = 1404 and dep.nmdepartment not like 'Tec%Informa%' and dep.nmdepartment not like 'Inform%Tec%'
