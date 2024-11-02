select usr.idlogin as Login,usr.nmuser as Nome, tm.nmteam as titulo, tm.idteam AS Equipe			
from adteam tm				
inner join adteammember tmm on tmm.cdteam = tm.cdteam				
inner join aduser usr on usr.cduser = tmm.cduser
where usr.fguserenabled =1 and usr.idlogin not like 'sesui%'
