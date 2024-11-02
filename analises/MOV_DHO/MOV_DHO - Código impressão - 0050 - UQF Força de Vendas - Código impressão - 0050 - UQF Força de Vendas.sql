select form.crp008 as unidade, wf.idprocess as identificador, wf.nmprocess as titulo, wf.idobject as codimpress
, 1 as quantidade
from DYNrhcp1 form
inner join GNFORMREG reg on reg.OIDENTITYREG = form.OID
inner join GNFORMREGGROUP grop on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP
inner join WFPROCESS wf on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join WFSTRUCT wfs on wf.idobject = wfs.idprocess
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
where wf.cdprocessmodel=86 and wfs.idstruct = 'Decisão1551912320809'
and wfs.DTENABLED is not null and DTEXECUTION is null and wf.fgstatus = 1
and form.crp008 like '0050 - UQF For%'
