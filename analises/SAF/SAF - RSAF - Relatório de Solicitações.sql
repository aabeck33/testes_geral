Select wf.idprocessmodel, wf.idprocess,  wf.nmprocess, wf.nmuserstart
, wf.dtstart as dtabertura, wf.dtfinish
, emp.ac001 as empresasolic
, emp.ac001 as filial
, prc.pf001 as processo
, subproc.fis001 as subprocesso
, form.ac002 as titulo
, coalesce (form.ac041, form.ac034, form.ac029, form.ac036, form.ac051, form.ac057) as empresa_cli
, coalesce (form.ac042, form.ac025, form.ac052, form.ac058) as forn_cli
, coalesce (form.ac006, form.ac026, form.ac053, form.ac059) as cnpj
, form.ac050 as justificativa
, tx.txdata as observ
, 1 as qtd
from dynpsafiscal form


inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNpsafiscal01 emp on (emp.oid=form.OIDABCMVYYYQ8S3KME)
inner join dynpsafiscal02 prc on (prc.oid = form.OIDABCRSIIMJNZVNFA)
inner join dynpsafiscal03 subproc on (subproc.oid = form.OIDABCD239BSBYB2GU)
inner join serichtext rt on (rt.oid=form.oidac012)
inner join setext html on (rt.oidhtmlcontent= html.oid)
inner join setext tx on (rt.oidtextcontent=tx.oid)
where wf.cdprocessmodel = 6869
