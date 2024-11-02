select usr.idlogin, usr.nmuser, plano.idactivity as plano, act.idactivity as acao
from gnactivity act
inner join aduser usr on usr.cduser = act.cduser
inner join gnactivity plano on plano.cdgenactivity = act.cdactivityowner
INNER JOIN gntask gntk on act.cdgenactivity = gntk.cdgenactivity
inner join gnactionplan actpl on act.cdactivityowner = actpl.cdgenactivity
INNER JOIN GNGENTYPE gntype ON gntype.CDGENTYPE = actpl.CDACTIONPLANTYPE
where act.fgstatus < 5 and act.CDACTIVITYOWNER is not null and gntype.idgentype = 'IN-LAB'
and usr.cduser not in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-089') 
and usr.cduser not in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-307')
and usr.cduser not in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-198')
and usr.cduser not in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-183')
