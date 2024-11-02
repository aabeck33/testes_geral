select form.crp008 as unidade, wf.idprocess, wf.nmprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador
, 1 as quantidade
from DYNrhcp1 form
inner join GNFORMREG reg on reg.OIDENTITYREG = form.OID
inner join GNFORMREGGROUP grop on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP
inner join WFPROCESS wf on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
where (
       (select count(form1.crp044) from DYNrhcp1 form1 inner join GNFORMREG regp on regp.OIDENTITYREG = form1.OID inner join GNFORMREGGROUP gropp on gropp.CDFORMREGGROUP = regp.CDFORMREGGROUP inner join WFPROCESS wfp on wfp.CDFORMREGGROUP = gropp.CDFORMREGGROUP INNER JOIN INOCCURRENCE INCp ON (wfp.IDOBJECT = INCp.IDWORKFLOW) LEFT OUTER JOIN GNREVISIONSTATUS GNrevp ON (INCp.CDSTATUS = GNrevp.CDREVISIONSTATUS) where form1.crp044 = form.crp044 and form1.crp001=4 and form1.crp001 = form.crp001 and wfp.fgstatus in (1,2,4,5) and gnrevp.CDREVISIONSTATUS not in (17,30)) > 1
    or (select count(form1.crp052) from DYNrhcp1 form1 inner join GNFORMREG regp on regp.OIDENTITYREG = form1.OID inner join GNFORMREGGROUP gropp on gropp.CDFORMREGGROUP = regp.CDFORMREGGROUP inner join WFPROCESS wfp on wfp.CDFORMREGGROUP = gropp.CDFORMREGGROUP INNER JOIN INOCCURRENCE INCp ON (wfp.IDOBJECT = INCp.IDWORKFLOW) LEFT OUTER JOIN GNREVISIONSTATUS GNrevp ON (INCp.CDSTATUS = GNrevp.CDREVISIONSTATUS) where form1.crp052 = form.crp052 and form1.crp001=1 and form1.crp001 = form.crp001 and form1.crp063=1 and form1.crp063 = form.crp063 and wfp.fgstatus in (1,2,4,5) and gnrevp.CDREVISIONSTATUS not in (17,30)) > 1
    or (select count(form1.crp030) from DYNrhcp1 form1 inner join GNFORMREG regp on regp.OIDENTITYREG = form1.OID inner join GNFORMREGGROUP gropp on gropp.CDFORMREGGROUP = regp.CDFORMREGGROUP inner join WFPROCESS wfp on wfp.CDFORMREGGROUP = gropp.CDFORMREGGROUP INNER JOIN INOCCURRENCE INCp ON (wfp.IDOBJECT = INCp.IDWORKFLOW) LEFT OUTER JOIN GNREVISIONSTATUS GNrevp ON (INCp.CDSTATUS = GNrevp.CDREVISIONSTATUS) where form1.crp030 = form.crp030 and form1.crp001=2 and form1.crp001 = form.crp001 and form1.crp064 = form.crp064 and wfp.fgstatus in (1,2,5) and gnrevp.CDREVISIONSTATUS not in (17,30)) > 1
    or (select count(form1.crp030) from DYNrhcp1 form1 inner join GNFORMREG regp on regp.OIDENTITYREG = form1.OID inner join GNFORMREGGROUP gropp on gropp.CDFORMREGGROUP = regp.CDFORMREGGROUP inner join WFPROCESS wfp on wfp.CDFORMREGGROUP = gropp.CDFORMREGGROUP INNER JOIN INOCCURRENCE INCp ON (wfp.IDOBJECT = INCp.IDWORKFLOW) LEFT OUTER JOIN GNREVISIONSTATUS GNrevp ON (INCp.CDSTATUS = GNrevp.CDREVISIONSTATUS) where form1.crp030 = form.crp030 and form1.crp001=3 and form1.crp001 = form.crp001 and form1.crp065 = form.crp065 and wfp.fgstatus in (1,2,5) and gnrevp.CDREVISIONSTATUS not in (17,30)) > 1
)
and wf.cdprocessmodel=86 and wf.fgstatus in (1,2,4,5) and gnrev.CDREVISIONSTATUS not in (17,30)
