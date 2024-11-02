select wf.idprocess as objeto, form.itsm022 as nmuser
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where wf.cdprocessmodel in (5251, 5470, 5692, 5679) and wf.fgstatus = 1
and exists (select 1 from aduser usr where usr.idlogin = form.itsm023 and usr.fguserenabled = 2)
union all
select form.itsm001 as objeto, form.itsm020 as nmuser
from DYNitsm001 form
where exists (select 1 from aduser usr where usr.idlogin = form.itsm019 and usr.fguserenabled = 2)
