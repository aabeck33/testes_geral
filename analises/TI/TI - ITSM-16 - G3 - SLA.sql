select wf.idprocess
, wf.dtfinish+tmfinish as dtfinish
, wf.dtstart+tmstart as dtstart
, ROUND (( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) AS SLAPERCENT
, case when ROUND (( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) < 100 then 1 else 0 end as slaok
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, coalesce(SLALC.QTRESOLUTIONTIME, 0) / 60 as sla
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
, (SELECT top 1 WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.idprocess = wf.idobject and str.idobject = wfa.idobject and (wfa.NMEXECUTEDACTION like '%Cancelar%' or wfa.NMEXECUTEDACTION like '%Encerrar%')
   and (str.idstruct = 'Atividade20131101317429' or str.idstruct = 'Atividade20131102332506' or 
   str.idstruct = 'Atividade20131102646273' or str.idstruct = 'Atividade2091512233371' or str.idstruct = 'Atividade201110173611852' or str.idstruct = 'Atividade2091512238643')
   and str.dtexecution+str.tmexecution = (SELECT max(str.dtexecution+str.tmexecution) FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.idprocess = wf.idobject and str.idobject = wfa.idobject and (wfa.NMEXECUTEDACTION like '%Cancelar%' or wfa.NMEXECUTEDACTION like '%Encerrar%')
   and (str.idstruct = 'Atividade20131101317429' or str.idstruct = 'Atividade20131102332506' or 
   str.idstruct = 'Atividade20131102646273' or str.idstruct = 'Atividade2091512233371' or str.idstruct = 'Atividade201110173611852' or str.idstruct = 'Atividade2091512238643'))
) as analista
, case when (form.itsm058 in (2, 6) and ROUND (( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) >= 100 and 
			         form.itsm003 in ('Lentidão', 'Erro/Falha', 'Indisponibilidade', 'Indisponibilidade de Impressão')) then 1
		   when (form.itsm058 in (1, 3, 4, 5, 11) and ROUND (( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) >= 100 and 
			         form.itsm003 in ('Lentidão', 'Erro/Falha', 'Indisponibilidade', 'Indisponibilidade de Impressão')) then 1
		    else 1 end as quant_tot
, 1 as quant_reg
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
inner JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL AND SLAH.FGCURRENT = 1) 
inner JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
where wf.cdprocessmodel = 5251 and wf.fgstatus = 4 and form.itsm035 is not null
and (datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()) or datepart(yyyy, wf.dtfinish) = case when datepart(month, getdate()) = 1 then datepart(yyyy, getdate()) - 1 else 0 end)
and ((wf.dtfinish >= '2022-04-01' and exists (select 1 from DYNitsm001 cat where cat.itsm001 = form.itsm006 and cat.itsm006 < 999)) or wf.dtfinish < '2022-04-01')
