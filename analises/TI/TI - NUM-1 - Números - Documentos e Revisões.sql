select ano, count(1) as quant
from (
select datepart(year, dtinsert) as ano
from dcdocrevision
) _sub
group by ano
