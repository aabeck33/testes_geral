select ano, count(1) as quant1, fguserenabled
, case fguserenabled when 2 then count(1) end quant2
from (
select case fguserenabled when 2 then datepart(year, dtupdate) else datepart(year, dtinsert) end as ano, fguserenabled
from aduser
) _sub
group by ano, fguserenabled
