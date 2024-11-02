select adc.idcompanies +' - '+ adc.nmcompanies as unidade, usr.idlogin, usr.nmuser
, case 
  when usr.cduser in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-307') 
  and usr.cduser in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-089')
  and usr.cduser in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-198')
  and usr.cduser in (select treusr.cduser
    from trtrainuser treusr
    inner join trtraining tre on tre.cdtrain = treusr.cdtrain
    inner join trcourse cou on cou.cdcourse = tre.cdcourse
    inner join DCDOCTRAIN tdoc on tre.cdtrain = tdoc.cdtrain
    inner join dcdocrevision rev on rev.cdrevision = tdoc.cdrevision and rev.fgcurrent = 1
    where rev.iddocument = 'POP-IN-O-183')

then 'Apto' else 'Inapto'
end status_INLAB

from aduser usr
inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join adcompanies adc on adc.cdcompanies = dep.cdcompanies
where usr.FGUSERENABLED = 1 and usr.nmdomainuid is not null
