select wf.idprocess, wf.nmprocess, usr.nmuser, usr.idlogin, wf.dtstart+wf.tmstart as dtinicio, wf.dtfinish+wf.tmfinish as dtfim
, (select case  when wfs.nmstruct = 'Atividade20131101317429' then 'N1'
                when wfs.nmstruct = 'Atividade20131102332506' then 'N2'
                when wfs.nmstruct = 'Atividade20131102646273' then 'N3'
                else 'N/A'
          end as N
    from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273') and wfs.DTEXECUTION+wfs.TMEXECUTION = (
        select max(wfs.DTEXECUTION+wfs.TMEXECUTION) from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273'))
) as atendN
, (select wfs.nmuser
    from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273') and wfs.DTEXECUTION+wfs.TMEXECUTION = (
        select max(wfs.DTEXECUTION+wfs.TMEXECUTION) from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.fgstatus = 3 and wfs.idstruct in ('Atividade20131101317429','Atividade20131102332506','Atividade20131102646273'))
) as atendAnalista
, (select case when wfs.fgstatus is not null then 'Sim' else 'Não' end from WFSTRUCT wfs where wfs.idprocess = wf.idobject and wfs.idstruct = 'Atividade20131101317429') as passouN1
, form.itsm066 + '_' + case when form.itsm088 is null then 'N1' else form.itsm088 end as gs_início
, form.itsm035 as gs_fim
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END  + ' - '+ gnrev.NMREVISIONSTATUS AS status
, form.itsm036 as unidserv
, form.itsm002 as objeto, form.itsm003 as servico
, case form.itsm058 
    when 1 then 'Solicitação' 
    when 2 then 'Incidente' 
    when 3 then 'Mudança' 
    when 4 then 'Projeto' 
    when 11 then 'Dúvida' 
    when 5 then 'Problema' 
    when 6 then 'Evento'
    else 'n/a'
end as tipofim
, form.itsm041 as paraQuem
, ROUND (( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2) AS SLAPERCENT
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join aduser usr on usr.cduser = wf.cduserstart
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
left JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL AND SLAH.FGCURRENT = 1) 
left JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
where wf.cdprocessmodel = 5251
