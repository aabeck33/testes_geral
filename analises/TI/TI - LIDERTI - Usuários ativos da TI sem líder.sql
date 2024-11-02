select idlogin, nmuser
from aduser usr
inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
where (dep.nmdepartment like 'Tecniologia da informa%' or dep.nmdepartment like 'Information Technol%')
and usr.fguserenabled = 1 and usr.cdleader is null
