select coord.itsm001 as coord, coord.itsm002, gs.itsm001 as gs
from DYNitsm016 coord
inner join DYNitsm017 gs on gs.OIDABCBSAGZNWY2N0Q = coord.oid
where exists (select 1 from aduser usr where usr.idlogin = coord.itsm002 and usr.fguserenabled = 2)
union all
select distinct 'Vazio' as coord, '' as itsm002, substring(adr.idrole,1,charindex('_',adr.idrole)-1) as gs
from adrole adr
where adr.fgenabled = 1 and adr.cdroleowner = 1404
and substring(adr.idrole,1,charindex('_',adr.idrole)-1) not in (select gs.itsm001
from DYNitsm016 coord
inner join DYNitsm017 gs on gs.OIDABCBSAGZNWY2N0Q = coord.oid)
