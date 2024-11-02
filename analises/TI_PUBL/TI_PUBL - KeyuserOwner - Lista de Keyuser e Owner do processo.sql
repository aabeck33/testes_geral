select usr.idlogin +' - '+ usr.nmuser as Usuario, t.idrole +' - '+ t.nmrole as Processo_Categoria, 1 as QTD
, uorg.iddepartment +' - '+ uorg.nmdepartment as unidorg, dep.iddepartment as idArea, dep.nmdepartment as area
from adrole t
inner join aduserrole tm on tm.cdrole = t.cdrole
inner join aduser usr on usr.cduser = tm.cduser and usr.fguserenabled =1
inner join aduserdeptpos rel on rel.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join addepartment uorg on (uorg.cdcompanies = dep.cdcompanies or dep.cddeptowner = uorg.cddepartment)
where t.idrole lIke  'SOL-ACESS_%' and usr.idlogin not like 'sesui%'
