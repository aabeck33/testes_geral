select wf.idprocess, wfs.DTEXECUTION, form.itsm056, depset.depart, depset.setor
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.idstruct = 'Decisão20111016323562'
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 is null or form.itsm035 = '') then '' else left(form.itsm035, charindex('_', form.itsm035)-1) end
inner join DYNitsm016 coord on lgs.OIDABCBSAGZNWY2N0Q = coord.oid
inner join (select oid, left(itsm001, charindex('_', itsm001) -1) as depart, right(itsm001, len(itsm001) - charindex('_', itsm001)) as setor from DYNitsm020) depset on depset.oid = coord.OIDABCKIK9UXB5HNKT
where wf.cdprocessmodel = 5679 and wfs.DTEXECUTION is not null
