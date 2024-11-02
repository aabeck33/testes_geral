select distinct dts.dtdate, usr0.idlogin, p2.nmuser, p2.dtdate as dtdtdt
, case when p2.nmuser is null then 'Não' else 'Sim' end acessou
, 1 as quant
from  (
  Select distinct dtdate from SECHANGETRANS
 ) as dts
cross join (select usr9.nmuser, usr9.idlogin
from  adaccessgroup acg
inner join COLICENSEKEY lik on lik.oid = acg.oidlicensekey and lik.nmid = 'NOMINATIVA'
inner join aduseraccgroup acgu on acgu.cdgroup = acg.cdgroup
inner join aduser usr9 on usr9.cduser = acgu.cduser
  ) usr0

left join (
select distinct log.nmuser, log.dtdate
from adaccessgroup acg
inner join COLICENSEKEY lik on lik.oid = acg.oidlicensekey and lik.nmid = 'NOMINATIVA'
inner join aduseraccgroup acgu on acgu.cdgroup = acg.cdgroup
inner join aduser usr on usr.cduser = acgu.cduser
inner join SECHANGETRANS log on log.nmuser = usr.idlogin +' - '+ usr.nmuser
  ) p2 on  p2.dtdate = dts.dtdate  and p2.nmuser = usr0.idlogin +' - '+ usr0.nmuser

where dts.dtdate > '2024-01-01'
and (DATENAME(dw, dts.dtdate) <> 'Sunday' and DATENAME(dw, dts.dtdate) <> 'Saturday')
