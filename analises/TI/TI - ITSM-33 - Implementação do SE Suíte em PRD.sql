select wf.idprocess,wf.nmprocess, formm.itsm028
, wf.dtstart + wf.tmstart as dtinicio, wf.dtfinish + wf.tmfinish as dtfim
, formm.ITSM027 as Real_Prd_Normal, formm.ITSM050 as DC_HOM, formm.ITSM003 as tec_resp
from wfprocess wf
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm form on (gnf.oidentityreg = form.oid)
inner join gnassocformreg gnfm on (wf.cdassocreg = gnfm.cdassoc)
inner join DYNitsm015 formm on (gnfm.oidentityreg = formm.oid)
where cdprocessmodel = 5679-- and formm.itsm028 between '2022-03-01' and '2022-03-31'
and form.itsm056 = 'SESUITE'
