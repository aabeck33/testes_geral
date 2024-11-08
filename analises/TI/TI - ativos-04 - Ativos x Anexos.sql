select OBJ.IDOBJECT + ' - ' + OBJ.NMOBJECT AS NM_FULLNAME
, adatta.idattachment, adatta.nmattachment, adatta.dsattachment, adatta.dtinsert
, 1 as qtd
FROM OBOBJECT OBJ 
INNER JOIN ASASSET ASAST ON (ASAST.CDASSET = OBJ.CDOBJECT AND ASAST.CDREVISION = OBJ.CDREVISION)
left join OBOBJECTATTACH atta on atta.CDOBJECT = ASAST.CDASSET and atta.CDREVISION = ASAST.CDREVISION
left join ADATTACHMENT adatta on adatta.CDATTACHMENT = atta.CDATTACHMENT
WHERE OBJ.FGCURRENT=1 AND OBJ.FGTEMPLATE <> 1
AND ASAST.FGASSTATUS <> 4
