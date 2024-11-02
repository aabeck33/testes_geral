select ano, count(1) as quant
from (
select datepart(year, tr.dtinsert) as ano
from trtraining tr
inner join trtrainuser mtr on mtr.cdtrain = tr.cdtrain
) _sub
group by ano
