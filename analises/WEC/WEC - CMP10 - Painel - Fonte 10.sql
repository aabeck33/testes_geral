Select coalesce(form.con012,'N/A') as con012
, sum(1) as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
where (wf.cdprocessmodel=2808 or wf.cdprocessmodel=2909 or wf.cdprocessmodel=2951)
and (gnrev.NMREVISIONSTATUS = 'Cancelado' or wf.fgstatus = 3)
group by con012
