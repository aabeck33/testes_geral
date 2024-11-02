select wf.idprocess as ident, wf.nmprocess as titulo
, gnrev.NMREVISIONSTATUS as etapa, wf.dtstart, wf.dtfinish
, case when formm.itsm026 = 1 then 'Emergencial'
       else case formm.itsm013
				when 1 then 'Normal'
				when 2 then 'Normal'
				when 3 then 'Simples'
				when 4 then 'Emergencial'
			end
end as tipo
, case formm.itsm047
    when 1 then 'Melhoria'
    when 2 then 'Corretiva'
    else case when (formm.itsm013 = 2) then 'Corretiva' else 'N/A' end
end as classif
, case formm.itsm048
    when 0 then 'Não BPx'
    when 1 then 'BPx'
    else case when (formm.itsm048 is null) then 'N/A' end
end as bpx
, case formm.itsm014
    when 1 then 'Crítica'
    when 2 then 'Não crítica'
end as critic
, case formm.itsm010
    when 1 then 'Sucesso'
    when 2 then 'Insucesso'
end as sucess
, case formm.itsm004
    when 1 then 'Baixo'
    when 2 then 'Médio'
    when 3 then 'Alto'
end as impacto
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS tituac
, case formm.itsm009 
    when 0 then 'Sem Rollback'
    when 1 then 'Com Rollback'
end as rback
, formm.itsm027 as implentini, formm.itsm028 as implentfim
, form.itsm002 as servti
, form.itsm004 as servneg
, form.itsm003 as sintserv
, form.itsm034 as descr
, formm.itsm020 as dataini
, formm.itsm021 as datafim
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, formm.itsm003 as resptec, formm.itsm002 as lidermud
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join gnassocformreg gnfm on (wf.cdassocreg = gnfm.cdassoc)
inner join DYNitsm015 formm on (gnfm.oidentityreg = formm.oid)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
where wf.cdprocessmodel = 5679
