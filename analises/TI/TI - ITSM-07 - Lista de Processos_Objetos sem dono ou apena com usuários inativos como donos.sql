select adr.idrole
from adrole adr
where adr.fgenabled = 1 and adr.cdroleowner = 1430 and (
-- vazio
not exists (select 1 from aduserrole adru where adru.cdrole = adr.cdrole) or
--só inativos
(select count(*) from aduserrole adru inner join aduser usr on usr.cduser = adru.cduser and usr.fguserenabled = 2 where adru.cdrole = adr.cdrole) = 
(select count(*) from aduserrole adru where adru.cdrole = adr.cdrole)
)
