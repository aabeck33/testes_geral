select usr.idlogin +' - '+ usr.nmuser as usuario, t.idrole, t.nmrole			
from adrole t				
inner join aduserrole tm on tm.cdrole = t.cdrole				
inner join aduser usr on usr.cduser = tm.cduser
where usr.fguserenabled =1 and usr.idlogin not like 'sesui%'
