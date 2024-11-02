select wf.idprocess as ID, wf.nmprocess as contrato, form.con012 as departamento
, wfs.nmstruct atividade, wfa.nmuser as aprovador
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFSTRUCT wfs on wfs.idprocess = wf.IDOBJECT
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
where ((wfs.idstruct = 'Decisão1951410726769' or wfs.idstruct = 'Decisão191210135022969' or wfs.idstruct = 'Decisão166614406373') 
 and (((select dep.nmdepartment from addepartment dep inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and fgdefaultdeptpos = 1 where rel.cduser = wfa.cduser) like '% informa%')
	   or (form.con012 like '% informa%')))
