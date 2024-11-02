select wf.idprocess, wf.dtfinish+wf.tmfinish as dtfinish, wf.dtstart+wf.tmstart as dtstart
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, case
    when (formmud.itsm013 = 1 and (formmud.itsm026 = 0 or formmud.itsm026 is null)) then 'Normal'
    when (formmud.itsm013 = 2 and (formmud.itsm026 = 0 or formmud.itsm026 is null)) then 'Normal'
    when (formmud.itsm013 = 3 and (formmud.itsm026 = 0 or formmud.itsm026 is null)) then 'Simples'
    when (formmud.itsm013 = 4 or formmud.itsm026 = 1) then 'Emergencial'
end as tipo
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
inner join gnassocformreg gnfmud on (wf.cdassocreg = gnfmud.cdassoc)
inner join DYNitsm015 formmud on (gnfmud.oidentityreg = formmud.oid)
where wf.cdprocessmodel = 5679 and form.itsm035 is not null and wf.fgstatus in (1, 4)
and ((datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()) or (datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()) -1 and datepart(mm, getdate()) = 1)) or (wf.dtfinish is null and (datepart(yyyy, wf.dtstart) = datepart(yyyy, getdate()) or (datepart(yyyy, wf.dtstart) = datepart(yyyy, getdate()) -1 and datepart(mm, wf.dtstart) = 12))))
