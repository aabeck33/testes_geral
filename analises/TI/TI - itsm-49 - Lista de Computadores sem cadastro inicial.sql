select obj.idobject, obj.nmobject, obj.dtinsert, obj.nmuserupd
, 'Cadastro de ativo feito pelo OCS primeira vez - Serial: '+ inv.nmworkgroup as nota
, 1 as qtd
from obobject obj
inner JOIN OBOBJECTATTRIB OBATTR on (OBATTR.CDOBJECT=OBJ.CDOBJECT AND OBATTR.CDREVISION=OBJ.CDREVISION)
inner join ASASTINVITCOMPUTER inv on inv.cdrevision = obj.cdrevision and inv.cdasset = obj.cdobject
WHERE OBATTR.CDATTRIBUTE = 895 and obj.fgcurrent = 1 and OBATTR.NMVALUE is null
and exists (
select 1
from ASASTINVITCOMPUTER inv
where inv.cdrevision = obj.cdrevision and inv.cdasset = obj.cdobject and inv.nmworkgroup is not null)

union all

select obj.idobject, obj.nmobject, obj.dtinsert, obj.nmuserupd
, 'Cadastro de ativo inconsistente. - Serial: '+ OBATTR.NMVALUE as nota
, 1 as qtd
from obobject obj
inner JOIN OBOBJECTATTRIB OBATTR on (OBATTR.CDOBJECT=OBJ.CDOBJECT AND OBATTR.CDREVISION=OBJ.CDREVISION)
WHERE OBATTR.CDATTRIBUTE = 895 and obj.fgcurrent = 1 and OBATTR.NMVALUE is not null
and not exists (
select 1
from ASASTINVITCOMPUTER inv
where inv.cdrevision = obj.cdrevision and inv.cdasset = obj.cdobject and inv.nmworkgroup is not null)

union all

select obj.idobject, obj.nmobject, obj.dtinsert, obj.nmuserupd
, 'Cadastro de ativo duplicado - Serial: '+ inv.nmworkgroup as nota
, 1 as qtd
from obobject obj
inner join ASASTINVITCOMPUTER inv on inv.cdrevision = obj.cdrevision and inv.cdasset = obj.cdobject
WHERE inv.nmworkgroup is not null and inv.nmworkgroup in (select inv1.nmworkgroup from ASASTINVITCOMPUTER inv1 where inv1.cdasset <> obj.cdobject)

union all

select obj.idobject, obj.nmobject, obj.dtinsert, obj.nmuserupd
, 'Computador sem condição associada. - Serial: '+ coalesce(inv.nmworkgroup, 'N/A') as nota
, 1 as qtd
from OBOBJECT OBJ 
INNER JOIN ASASSET ASAST ON (ASAST.CDASSET=OBJ.CDOBJECT AND ASAST.CDREVISION=OBJ.CDREVISION)
INNER JOIN OBOBJECTGROUP OBJGRP ON (OBJGRP.CDOBJECTGROUP=OBJ.CDOBJECT) 
INNER JOIN OBOBJECTTYPE OBJTYPE ON (OBJTYPE.CDOBJECTTYPE=OBJGRP.CDOBJECTTYPE)
inner join ASASTINVITCOMPUTER inv on inv.cdrevision = obj.cdrevision and inv.cdasset = obj.cdobject
left join ASHISTASSETSTATE estado on estado.cdasset = asast.cdasset and estado.cdrevision = asast.cdrevision
where OBJTYPE.cdobjecttype = 5 and estado.cdstate is null
