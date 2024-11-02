select wf.idprocess, wf.dtfinish+wf.tmfinish as dtfinish, wf.dtstart+wf.tmstart as dtstart
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, case form.itsm058
    when 1 then 'Solicitação'
    when 11 then 'Solicitação'
    when 2 then 'Incidente'
    when 3 then 'Solicitação'
    when 4 then 'Solicitação'
    when 5 then 'Solicitação'
    when 6 then 'Incidente'
  end as tipofim
, form.itsm006 as servicoID
, form.itsm070 as categoria, form.itsm002 as objeto, form.itsm003 as servico, form.itsm004 as complemento
, form.itsm034 as descricao
, form.itsm043 as resultado
, (select wfs.idstruct from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273') and wfs.DTEXECUTION+wfs.TMEXECUTION = (
        select max(wfs.DTEXECUTION+wfs.TMEXECUTION) from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273'))
) as atendN
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
where wf.cdprocessmodel = 5251 and form.itsm035 is not null and wf.fgstatus = 4
