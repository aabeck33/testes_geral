select perf.itsm001, perf.itsm002, perf.itsm003, perf.itsm004, perf.itsm007, perf.itsm009
from DYNitsm021 perf
inner join aduser usr on usr.idlogin = perf.itsm008
where usr.fguserenabled <> 1
