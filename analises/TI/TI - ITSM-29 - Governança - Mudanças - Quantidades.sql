select wf.idprocess as ident
, case when formm.itsm026 = 1 then 'Emergencial'
       else case formm.itsm013
				when 1 then 'Normal'
				when 2 then 'Normal'
				when 3 then 'Simples'
				when 4 then 'Emergencial'
			end
end as tipo
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN case when gnrev.idREVISIONSTATUS = 'ITSM-11' then 'Cancelado' else 'Encerrado' end
    WHEN 5 THEN 'Bloqueado para edição'
END AS situac
, wf.dtstart + wf.tmstart as inic
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join wfstruct wfs on wf.idobject = wfs.idprocess
inner join gnassocformreg gnfm on (wf.cdassocreg = gnfm.cdassoc)
inner join DYNitsm015 formm on (gnfm.oidentityreg = formm.oid)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where wf.cdprocessmodel = 5679 and ((wfs.fgstatus = 2 or wfs.fgstatus = 3) and wfs.idstruct = 'Atividade20111012624715')
