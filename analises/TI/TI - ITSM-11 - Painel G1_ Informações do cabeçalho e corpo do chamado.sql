select wf.idprocess as identificador, wf.nmprocess, form.itsm033 as descricao
, wf.nmuserstart as quemPediu
, (select distinct unid.iddepartment +' - '+ unid.nmdepartment from addepartment dep inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and rel.FGDEFAULTDEPTPOS = 1 and rel.cduser = wf.cduserstart inner join addepartment unid on unid.cddepartment = dep.cddeptowner) as quemPediuUnid
, (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and rel.FGDEFAULTDEPTPOS = 1 and rel.cduser = wf.cduserstart) as quemPediuDep
, (select pos.idposition +' - '+ pos.nmposition from adposition pos inner join aduserdeptpos rel on rel.cdposition = pos.cdposition and rel.FGDEFAULTDEPTPOS = 1 and rel.cduser = wf.cduserstart) as quemPediuPos
, form.itsm041 as paraQuemPediu, form.itsm048 as paraQuemPediuUnid, case when (select nmdepartment from addepartment where iddepartment = form.itsm040) is null then form.itsm040 else (select nmdepartment from addepartment where iddepartment = form.itsm040) end as paraQuemPediuDep, form.itsm039 as paraQuemPediuPos
, form.itsm036 as unidserv, form.itsm070 as categserv
, form.itsm002 as objeto, form.itsm006 as servico, form.itsm003 as Serviço_Descricao, form.itsm004 as complemento, form.itsm049 as detalhe
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento - '+gnrev.NMREVISIONSTATUS WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado - '+ gnrev.NMREVISIONSTATUS
WHEN 5 THEN 'Bloqueado para edição' END AS status
, case when BNSLAFINISH is null then DATEADD(ms, gnslactrl.BNSLAFINISHPLAN % 1000, DATEADD(ss, gnslactrl.BNSLAFINISHPLAN/1000, CONVERT(DATETIME2(3),'19700101')))
       else  DATEADD(ms, gnslactrl.BNSLAFINISH % 1000, DATEADD(ss, gnslactrl.BNSLAFINISH/1000, CONVERT(DATETIME2(3),'19700101'))) end as quandoFicaPronto
, case gnslactrl.FGSLAFINISHSTATUS when 1 then 'Em dia' when 2 then 'Em atraso' else 'N/A' end pzstatus
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
, restx.NMEVALRESULT as prioridade
, case when depset.depart is null then 'N/A' else depset.depart end depart
, case when depset.setor is null then 'N/A' else depset.setor end setor
, wf.dtstart + wf.tmstart as dtinicio, wf.dtfinish + wf.tmfinish as dtfim
, form.itsm035 as GS
, case when wf.fgstatus = 1 then round(((select coalesce(sum(QTTIMECALENDAR), 0) + coalesce((select datediff(ss, CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(BNSTART AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')), CONVERT(DATETIME, GETDATE())) from GNSLACTRLSTATUS where CDSLACONTROL = (select cdslacontrol from wfprocess where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is null and idprocess = wf.idprocess)),0)
          from GNSLACTRLSTATUS where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is not null and CDSLACONTROL = wf.cdslacontrol) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60)), 2)
       else ROUND(( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2)
end as slapercent
, serv.itsm006 as SLA, case serv.itsm007
    when 1 then 'Solicitação'
    when 2 then 'Incidente'
    when 3 then 'Mudança'
    when 4 then 'Projeto'
    when 5 then 'Problema'
    when 6 then 'Evento'
end as tiposrv, subc.itsm003 as subcat
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
inner join GNSLA gnsla on gnsla.cdsla = gnslactrl.cdsla and gnsla.FGENABLED = 1
left join DYNitsm001 serv on serv.itsm001 = form.itsm006
left join DYNitsm003 subc on serv.OIDABC33MU921YCVUK = subc.oid
left JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL AND SLAH.FGCURRENT = 1) 
left JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 is null or form.itsm035 = '') then '' else left(form.itsm035, charindex('_', form.itsm035)-1) end
left join DYNitsm016 resp on resp.oid = lgs.OIDABCBSAGZNWY2N0Q
left join (select oid, left(itsm001, charindex('_', itsm001) -1) as depart, right(itsm001, len(itsm001) - charindex('_', itsm001)) as setor from DYNitsm020) depset on depset.oid = resp.OIDABCKIK9UXB5HNKT
left join GNEVALRESULTUSED res on res.CDEVALRESULTUSED = wf.CDEVALRSLTPRIORITY
left join GNEVALRESULT restx on restx.CDEVALRESULT = res.CDEVALRESULT
where wf.cdprocessmodel = 5251 
and (datepart(yyyy, wf.dtstart) = datepart(yyyy, getdate()) or datepart(yyyy, wf.dtstart) = case when datepart(month, getdate()) = 1 then datepart(yyyy, getdate()) - 1 else 0 end)
and wf.fgstatus < 6
