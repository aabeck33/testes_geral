select wf.idprocess, wf.dtstart+wf.tmstart as dtabertura, wf.dtfinish+wf.tmfinish as dtencerramento, form.itsm006 as servicoID
, form.itsm070 as categoria, form.itsm002 as objeto, form.itsm003 as servico, form.itsm004 as complemento
, form.itsm034 as descricao
, form.itsm056 as gruposolucionador
, case itsm058
    when 1 then 'Solicitação'
    when 2 then 'Incidente'
    when 3 then 'Mudança'
    when 4 then 'Projeto'
    when 5 then 'Problema'
    when 6 then 'Evento'
    when 11 then 'Dúvida'
end as tipo
, case when wf.fgstatus = 1 then case when round(((select coalesce(sum(QTTIMECALENDAR), 0) + 
                                                          coalesce((select datediff(ss, CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(BNSTART AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')), CONVERT(DATETIME, GETDATE()))
                                                                    from GNSLACTRLSTATUS
                                                                    where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is null and CDSLACONTROL = wf.CDSLACONTROL),0)
                                                   from GNSLACTRLSTATUS 
                                                   where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is not null and CDSLACONTROL = wf.cdslacontrol) 
                                  * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60)), 2) < 100 then 'SLA_Ok' else 'SLA_NOk' end
    else case when ROUND(( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) < 100 then 'SLA_Ok' else 'SLA_NOk' end 
end as sla
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
from DYNitsm form, gnassocformreg gnf, wfprocess wf, GNSLACONTROL gnslactrl
left JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL and SLAH.FGCURRENT = 1) 
left JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
where wf.cdprocessmodel = 5251 and wf.fgstatus < 6
and gnf.oidentityreg = form.oid and wf.cdassocreg = gnf.cdassoc and gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
and datepart(yyyy, wf.dtstart) = datepart(yyyy, getdate())
