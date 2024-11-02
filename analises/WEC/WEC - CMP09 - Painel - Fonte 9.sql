Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, wf.dtstart, struc.nmstruct as nmatvatual, struc.dtenabled as dtiniatvatual
, struc.dtestimatedfinish as przatvatual
, case when HIS.NMUSER is null then HIS.nmrole else HIS.NMUSER end as executatvatual
, coalesce((select dep1.iddepartment +' - '+ dep1.nmdepartment from aduser usr1 inner join aduserdeptpos rel1 on rel1.cduser = usr1.cduser and rel1.fgdefaultdeptpos = 1 inner join addepartment dep1 on dep1.cddepartment = rel1.cddepartment where usr1.cduser = HIS.cdUSER), HIS.nmrole) as executarea
, case when wf.cdprocessmodel <> 2951 then combo1.con001 else 'Distrato' end as tipocontr
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DYNcon001espec combo1 on combo1.oid = form.OIDABCzgOABC2Ih
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.fgtype = 6
inner JOIN WFSTRUCT struc ON HIS.IDSTRUCT = struc.IDOBJECT and struc.idprocess = wf.idobject and struc.fgstatus = 2
and HIS.DTHISTORY+HIS.TMHISTORY = (select max(HIS1.DTHISTORY+HIS1.TMHISTORY) FROM WFHISTORY HIS1 where his1.fgtype = 6 and his1.idprocess = wf.idobject and his1.idstruct = struc.idobject)
where (wf.cdprocessmodel = 2808 or wf.cdprocessmodel = 2909 or wf.cdprocessmodel = 2951)
and wf.fgstatus = 1
