SELECT wf.idprocess, GNEXECUSR.VLNOTE
, wf.dtfinish
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, 1 as quant
FROM GNACTIVITY GNACT
INNER JOIN SVSURVEY SRV ON (GNACT.CDGENACTIVITY=SRV.CDGENACTIVITY)
inner JOIN GNSURVEYEXEC GNSUREXEC ON (GNSUREXEC.CDSURVEYEXEC=SRV.CDSURVEYEXEC)
INNER JOIN GNSURVEYEXECUSER GNEXECUSR ON (GNSUREXEC.CDSURVEYEXEC=GNEXECUSR.CDSURVEYEXEC)
inner join WFSURVEYEXECPROC wfsur on wfsur.CDSURVEYEXECUSER = GNEXECUSR.CDSURVEYEXECUSER
inner join wfprocess wf on wf.idobject = wfsur.idobject
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm form on (gnf.oidentityreg = form.oid)
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
WHERE wf.cdprocessmodel = 5251 and wf.fgstatus = 4 and vlnote is not null
and (datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()) or datepart(yyyy, wf.dtfinish) = case when datepart(month, getdate()) = 1 then datepart(yyyy, getdate()) - 1 else 0 end)
