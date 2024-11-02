select coa.cduser,coa.idlogin, usr.fguserenabled
, 1 as qtd
from coaccount coa
inner join aduser usr on usr.cduser = coa.cduser
where coa.nmdomainuid is null
and exists (select 1 from aduseraccgroup acc where acc.cduser = usr.cduser and cdgroup <> 76)
