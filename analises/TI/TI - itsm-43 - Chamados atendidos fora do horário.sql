select wf.idprocess
, case  when wfs.nmstruct = 'Atividade20131101317429' then 'N1'
                when wfs.nmstruct = 'Atividade20131102332506' then 'N2'
                when wfs.nmstruct = 'Atividade20131102646273' then 'N3'
                else 'N/A'
          end as atendN
, wfs.nmuser as atendAnalista
, wfs.DTEXECUTION+wfs.tmexecution as dtexecut
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273')
where wf.cdprocessmodel = 5251
