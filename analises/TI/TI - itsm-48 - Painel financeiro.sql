select fin.itsm001 as ger
, grid.*
, 1 as quant
from DYNitsm022 fin
inner join DYNitsm022x001 grid on grid.OIDABCBTXHVX631Q07 = fin.oid
