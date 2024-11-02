select 
        distinct obj.idobject as Identificador,
				case when  idattachment is null then 0 else 1 end as Anexo,
		case when obj.nmobject like 'ak%' then 'Arklok' else 'UQFN' end as Propriedade,
		obj.nmobject as Nome_Computador,
		site.idsite as ID_localização,
		site.nmsite as Localização,
        obj.dtinsert as Data_Cadastro,
        ADATV.NMATTRIBUTE,
        OBATTR.NMVALUE ,
        ADAT.IDATTACHMENT ,
        ADAT.NMATTACHMENT 
    from
        obobject obj 
		INNER JOIN ASASSET ASAST ON (ASAST.CDASSET=OBJ.CDOBJECT AND ASAST.CDREVISION = OBJ.CDREVISION)
		left join OBOBJECTATTRIB OBATTR on(OBATTR.CDOBJECT=OBJ.CDOBJECT AND OBATTR.CDREVISION=OBJ.CDREVISION)
		left join ADATTRIBVALUE ADATV on (ADATV.CDATTRIBUTE=OBATTR.CDATTRIBUTE AND ADATV.CDVALUE=OBATTR.CDVALUE)
		left join OBOBJECTATTACH OBAT on OBATTR.CDOBJECT=OBAT.CDOBJECT
		left join ADATTACHMENT ADAT on ADAT.CDATTACHMENT=OBAT.CDATTACHMENT
		left join ASHISTASSETSITE locali on locali.cdasset = ASAST.cdasset and locali.cdrevision = ASAST.cdrevision and 
          (locali.dthistory+locali.tmhistory = (select max(locali2.dthistory+locali2.tmhistory)
                                                from ASHISTASSETSITE locali2
                                                where locali2.cdasset = locali.cdasset and locali2.cdrevision = locali.cdrevision))
		left join assite site on site.cdsite = locali.cdsite
WHERE OBJ.FGCURRENT=1 AND OBJ.FGTEMPLATE <> 1
AND ASAST.FGASSTATUS <> 4
