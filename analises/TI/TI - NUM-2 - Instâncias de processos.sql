select ano, count(1) as quant
from (
select datepart(year, dtstart) as ano
from wfprocess
) _sub
group by ano
