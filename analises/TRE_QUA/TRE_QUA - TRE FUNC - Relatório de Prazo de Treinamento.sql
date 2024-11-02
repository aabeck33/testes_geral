Select form.r005 as DATA_Inicio_Nova_FUNCAO, form.r007 as DataLimite
,CASE WHEN (form.r007 is not null and datediff(dd,getdate(),form.r007) <=0) THEN 'NAO CONFORME'
when (form.r007 is null) then 'N/A'
ELSE 'CONFORME'
END as SITUACAO
, usr.iduser, SUBSTRING(pos1.idposition, 1, charindex('-',pos1.idposition)-1) as unid
, grid_USR.iduser as Login, grid_USR.nmuser as Usuario, grid_USR.nmarea +'-'+ grid_USR.nmfuncao as Area_Funcao
, grid_func.idrole as ID_ROLE, grid_func.nmrole as NM_ROLE
, dep.nmdepartment, pos.nmposition, 1 as quantidade
, revc.iddocument, revc.nmtitle as NMDOCUMENT, gnrevc.idrevision
from DYNgerole form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNgriduserroles grid_USR on grid_USR.OIDABCQMLGWPXYPK9U = form.oid
inner join DYNgrdfunc grid_func on grid_func.OIDABC9Q4925ZYS5T2= form.oid
inner join aduser usr on usr.idlogin = grid_USR.iduser
inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join adposition pos on pos.cdposition = rel.cdposition
inner join adposition pos1 on pos1.idposition = grid_func.idrole
inner join addeptposition deppos on deppos.cdposition = pos1.cdposition and deppos.cddepartment = 164
inner join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
inner join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
inner join dcdocument doc on doc.cddocument = docc.cddocument and doc.fgstatus <> 4
inner join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
inner join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
where wf.cdprocessmodel = 5396
and exists (select 1 from adposition posp inner join aduserdeptpos relp on relp.cdposition = posp.cdposition and fgdefaultdeptpos = 2 where posp.idposition = grid_func.idrole and relp.cduser = usr.cduser)
and not exists (select 1 from trtraining tr inner join DCDOCTRAIN tdoc on tr.cdtrain = tdoc.cdtrain inner join trtrainuser trusr on trusr.cdtrain = tr.cdtrain where tr.fgcancel <> 1 and tdoc.cddocument = revc.cddocument and trusr.cduser = usr.cduser)
