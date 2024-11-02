select obobj.idobject, obobj.NMOBJECT, bios.NMSERIALNUMBER, bios.NMTYPE, bios.NMMANUFACTURER
, comp.NMUSERNAME, comp.NMIPADDRESS, comp.NMUSERDOMAIN
, case ass.fgasstatus
	when 1 then 'Verificação'
	when 2 then 'Mov.para utilização' 
	when 3 then 'Mov.para manutenção'
	when 4 then 'Desativado'
	when 5 then 'Disponível'
	when 6 then 'Mov.paracalibração'
	when 7 then 'Calibração em execução'
	when 8 then 'Aprovação de calibração'
	when 9 then 'Análise de NC'
	when 10 then 'Manutenção'
end Status
, 1 as quant
from ASASSET ass
INNER JOIN OBOBJECT obobj ON obobj.CDOBJECT = ass.CDASSET AND obobj.CDREVISION = ass.CDREVISION
inner join ASASTINVITCOMPUTER comp on comp.CDASSET = obobj.CDOBJECT and comp.CDREVISION = obobj.CDREVISION
inner join ASASTINVCPBIOS bios on bios.CDASTINVITCOMPUTER = comp.CDASTINVITCOMPUTER
where ass.CDREVISION = (select max(ass1.CDREVISION) from ASASSET ass1 where ass1.cdasset = ass.cdasset)
and comp.CDASTINVITCOMPUTER = ( select max(comp1.CDASTINVITCOMPUTER)
                                from ASASTINVITCOMPUTER comp1
                                inner join ASASTINVENTORY asinv on asinv.CDASTINVENTORY = comp1.CDASTINVENTORY
                                where comp1.CDASSET = comp.CDASSET and comp1.CDREVISION = comp.CDREVISION )
