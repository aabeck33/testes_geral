select * from (
select case when pilar is null then 'Total'
       else pilar end pilar
, quant
from (
select count(*) as quant
, substring(actp.nmactivity, charindex(' - ', actp.nmactivity, 1)+3, charindex(' - ', actp.nmactivity, 8) - charindex(' - ', actp.nmactivity, 1)-3) as pilar
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactionplan actpl on actp.cdgenactivity = actpl.cdgenactivity
INNER JOIN GNGENTYPE gntype ON gntype.CDGENTYPE = actpl.CDACTIONPLANTYPE
where gntype.CDGENTYPEOWNER = 53 and actp.nmactivity like '0053 - %'  and actp.fgstatus = 5 and case when charindex(' - ', actp.nmactivity, 1) = 0 or charindex(' - ', actp.nmactivity, 8) = 0 then 'N/A' else 
substring(actp.nmactivity, charindex(' - ', actp.nmactivity, 1)+3, charindex(' - ', actp.nmactivity, 8) - charindex(' - ', actp.nmactivity, 1)-3) end in ('Custos', 'Pessoas', 'Produtividade', 'Qualidade')
group by substring(actp.nmactivity, charindex(' - ', actp.nmactivity, 1)+3, charindex(' - ', actp.nmactivity, 8) - charindex(' - ', actp.nmactivity, 1)-3)
with rollup
) _sub
) _sub2
