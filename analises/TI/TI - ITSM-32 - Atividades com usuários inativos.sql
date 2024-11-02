select wf.idprocess, wfs.nmstruct, usr.nmuser, wf.nmuserstart, wf.nmprocess, itsm035
from wfprocess wf
inner join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 2
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
inner join aduser usr on usr.cduser = wfa.cduser and fguserenabled = 2
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm form on (gnf.oidentityreg = form.oid)
where wf.cdprocessmodel in (5283, 5267, 5273, 5279,5251, 5470, 5692, 5679, 5716, 5756)
and wf.fgstatus < 4
