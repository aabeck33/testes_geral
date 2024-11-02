SELECT OBJ.IDOBJECT, OBJ.NMOBJECT, OBJ.IDOBJECT + ' - ' + OBJ.NMOBJECT AS NM_FULLNAME
, ASINVPC.NMOS, ASINVPC.NMIPADDRESS, ASINVPC.NMUSERNAME, usr.nmuser, usr.fguserenabled
, OBJTYPE.nmobjecttype as objTipo, site.idsite, site.nmsite, dep.iddepartment, dep.nmdepartment
, case when OBJ.NMOBJECT like 'ak%' then 'T' else 'P' end as propriedade
, case when bios.nmtype like '%desktop%' then 'Desktop'
       when bios.nmtype like '%tower%' then 'Desktop'
       when bios.nmtype like '%notebook%' then 'Notebook'
       when bios.nmtype like '%portable%' then 'Notebook'
       when bios.nmtype like '%laptop%' then 'Notebook'
       when bios.nmtype like '%thinkpad%' then 'Notebook'
       when bios.nmtype like '%chassis%' then 'Servidor'
       when bios.nmtype like '%other%' then 'Servidor'
       else case when OBJ.NMOBJECT like 'akd%' then 'Desktop'
                 when OBJ.NMOBJECT like 'akn%' then 'Notebook'
                 when OBJ.NMOBJECT like 'd%' then 'Desktop'
                 when OBJ.NMOBJECT like 'n%' then 'Notebook'
                 else 'N/A'
            end
 end as nmtype
, ASAST.DTSTARTOPER
, (select top 1 case when cpu.nmtype like '%i3%' then 'I3'
                     when cpu.nmtype like '%i5%' then 'I5'
                     when cpu.nmtype like '%i7%' then 'I7'
                     when cpu.nmtype like '%xeon%' then 'XEON'
                     when cpu.nmtype like '%2 duo%' then '2 DUO'
                     when cpu.nmtype like '%AMD%' then 'AMD'
                     when cpu.nmtype like '%dual%' then 'Dual-Core'
                     when cpu.nmtype like '%celeron%' then 'Celeron'
                     when cpu.nmtype like '%quad%' then 'Quad-Core'
                     when cpu.nmtype like '%atom%' then 'Atom'
                     else 'Outro' end as cputype
   from ASASTINVCPCPU cpu where cpu.CDASTINVITCOMPUTER = ASINVPC.CDASTINVITCOMPUTER) as cputype
, (select sum(coalesce(mem.VLCAPACITYMB,0)) from ASASTINVCPMEMORY mem where mem.CDASTINVITCOMPUTER = ASINVPC.CDASTINVITCOMPUTER) as memMB
, datediff(DD, ASINV.dtimport, getdate()) as desdeUltReport
, ASINV.dtimport as dtUltReport
, 1 as qtd
FROM OBOBJECT OBJ
INNER JOIN OBOBJECTGROUP OBJGRP ON (OBJGRP.CDOBJECTGROUP=OBJ.CDOBJECT)
INNER JOIN OBOBJECTTYPE OBJTYPE ON (OBJTYPE.CDOBJECTTYPE=OBJGRP.CDOBJECTTYPE)
INNER JOIN ASASSET ASAST ON (ASAST.CDASSET=OBJ.CDOBJECT AND ASAST.CDREVISION = OBJ.CDREVISION)
left JOIN ASASTINVITCOMPUTER ASINVPC ON (ASAST.CDASSET=ASINVPC.CDASSET AND ASAST.CDREVISION = ASINVPC.CDREVISION)
left JOIN ASASTINVENTORY ASINV ON (ASINVPC.CDASTINVENTORY=ASINV.CDASTINVENTORY)
left join ASASTINVCPBIOS bios on bios.CDASTINVITCOMPUTER = ASINVPC.CDASTINVITCOMPUTER
left join ASHISTASSETSITE locali on locali.cdasset = ASAST.cdasset and locali.cdrevision = ASAST.cdrevision and 
          (locali.dthistory+locali.tmhistory = (select max(locali2.dthistory+locali2.tmhistory)
                                                from ASHISTASSETSITE locali2
                                                where locali2.cdasset = locali.cdasset and locali2.cdrevision = locali.cdrevision))
left join assite site on site.cdsite = locali.cdsite
left join aduser usr on usr.idlogin = ASINVPC.NMUSERNAME
left join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
WHERE OBJ.FGCURRENT = 1 AND OBJ.FGTEMPLATE <> 1
AND (ASINVPC.CDASTINVENTORY IS NULL OR ASINVPC.CDASTINVENTORY = (
     SELECT MAX(CDASTINVENTORY) FROM ASASTINVITCOMPUTER ASPC WHERE ASPC.CDASSET = ASAST.CDASSET AND ASPC.CDREVISION = ASAST.CDREVISION))
AND ASAST.FGASSTATUS <> 4 and OBJTYPE.cdobjecttype in (4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
