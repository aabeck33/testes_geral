select form.itsm001 as servico, pop.itsm001 as pop
from DYNitsm001 form
left join DYNitsm005 pop on pop.OIDABCOF6I5OE0ST0Q = form.oid
