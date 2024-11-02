select usr.idlogin, usr.nmuser, pos.idposition, pos.nmposition
, case when CHARINDEX('-', pos.idposition) <> 0 then SUBSTRING(pos.idposition, CHARINDEX('-', idposition)+1, 2) else '' end as setor
, case when CHARINDEX('-', pos.idposition) <> 0 then SUBSTRING(pos.idposition, 1, charindex('-', pos.idposition)-1) else '' end as unid
,1 as quantidade
from aduser usr
inner join aduserdeptpos rel on usr.cduser = rel.cduser and rel.FGDEFAULTDEPTPOS = 2 and rel.cddepartment = 164
inner join adposition pos on rel.cdposition = pos.cdposition and pos.fgposenabled = 1 and (pos.idposition like 'PA0052%')
where usr.fguserenabled = 1
