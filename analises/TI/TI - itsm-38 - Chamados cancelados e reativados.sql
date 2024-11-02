select wf.idprocess, wf.nmprocess, wf.dtstart
, CASE WHEN HIS.FGTYPE=1 THEN '#{214623}' WHEN HIS.FGTYPE=2 THEN '#{214626}' WHEN HIS.FGTYPE=3 THEN '#{214624}' WHEN HIS.FGTYPE=4 THEN '#{214622}' WHEN HIS.FGTYPE=5 THEN '#{214625}' WHEN HIS.FGTYPE=6 THEN '#{108524}' WHEN HIS.FGTYPE=7 THEN '#{108521}' WHEN HIS.FGTYPE=8 THEN '#{108523}'
WHEN HIS.FGTYPE=9 OR HIS.FGTYPE=13 THEN CASE WHEN HIS.FGEXECACTIVITY=1 THEN '#{109792}' ELSE '#{108515}' END WHEN HIS.FGTYPE=10 THEN '#{108522}' WHEN HIS.FGTYPE=11 THEN '#{207321}' WHEN HIS.FGTYPE=12 THEN '#{111081}' WHEN HIS.FGTYPE=14 THEN '#{202998}' WHEN HIS.FGTYPE=15 THEN '#{203001}' WHEN HIS.FGTYPE=16 THEN '#{203157}' WHEN HIS.FGTYPE=17 THEN '#{300627}' WHEN HIS.FGTYPE=18 THEN '#{205986}' WHEN HIS.FGTYPE=19 THEN '#{206047}' WHEN HIS.FGTYPE=20 THEN '#{206045}' WHEN HIS.FGTYPE=21 THEN '#{206395}' WHEN HIS.FGTYPE=22 THEN '#{206396}' WHEN HIS.FGTYPE=23 THEN '#{206397}' WHEN HIS.FGTYPE=24 THEN '#{206398}' WHEN HIS.FGTYPE=25 THEN '#{206399}' WHEN HIS.FGTYPE=26 THEN '#{206400}' WHEN HIS.FGTYPE=27 THEN '#{206401}' WHEN HIS.FGTYPE=28 THEN '#{206402}' WHEN HIS.FGTYPE=29 THEN '#{300628}' WHEN HIS.FGTYPE=30 THEN '#{300629}' WHEN HIS.FGTYPE=31 THEN '#{207878}' WHEN HIS.FGTYPE=32 THEN '#{212328}' WHEN HIS.FGTYPE=33 THEN '#{214355}' WHEN HIS.FGTYPE=34 THEN '#{214354}' WHEN HIS.FGTYPE=35 THEN '#{205979}' WHEN HIS.FGTYPE=36 THEN '#{214357}' WHEN HIS.FGTYPE=37 THEN '#{214356}' WHEN HIS.FGTYPE=40 THEN '#{218247}' WHEN HIS.FGTYPE=41 THEN '#{202818}' WHEN HIS.FGTYPE=42 THEN '#{300509}' WHEN HIS.FGTYPE=43 THEN '#{300510}' WHEN HIS.FGTYPE=44 THEN '#{300511}' WHEN HIS.FGTYPE=45 THEN '#{300512}' WHEN HIS.FGTYPE=46 THEN '#{300513}' WHEN HIS.FGTYPE=47 THEN '#{300514}' WHEN HIS.FGTYPE=48 THEN '#{219451}' WHEN HIS.FGTYPE=50 THEN '#{300296}' WHEN HIS.FGTYPE=51 THEN '#{300297}' WHEN HIS.FGTYPE=52 THEN '#{302481}' WHEN HIS.FGTYPE=53 THEN '#{302482}' WHEN HIS.FGTYPE=71 THEN '#{300310}' WHEN HIS.FGTYPE=72 THEN '#{308378}' WHEN HIS.FGTYPE=73 THEN '#{308379}' WHEN HIS.FGTYPE=74 THEN '#{308380}'
END AS nmTYPE
, his.DSCOMMENT as jutific, his.dthistory+his.tmhistory as dtcancel
, case his.fgtype when 3 then 'Instância cancelada' when 5 then 'Instância reativada' else cast(his.fgtype as varchar) end fgtype
, coalesce(SLALC.QTRESOLUTIONTIME, 0) / 60 as sla
, case when wf.fgstatus = 1 then round(((select coalesce(sum(QTTIMECALENDAR), 0) + coalesce((select datediff(ss, CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(BNSTART AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')), CONVERT(DATETIME, GETDATE())) from GNSLACTRLSTATUS where CDSLACONTROL = (select cdslacontrol from wfprocess where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is null and idprocess = wf.idprocess)),0)
          from GNSLACTRLSTATUS where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is not null and CDSLACONTROL = wf.cdslacontrol) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60)), 2)
       else ROUND(( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2)
end as slapercent
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, case when exists (select distinct(his2.idprocess) from wfhistory his2 where his2.idprocess = his.idprocess and his2.fgtype = 5 and his2.dthistory+his2.tmhistory < his.dthistory+his.tmhistory) then 'Sim' else 'Não' end reativado
, 1 as quantidade
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
inner JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL AND SLAH.FGCURRENT = 1) 
inner JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.FGTYPE = 3
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
where wf.cdprocessmodel = 5251 and wf.fgstatus = 3
and case when wf.fgstatus = 1 then round(((select coalesce(sum(QTTIMECALENDAR), 0) + coalesce((select datediff(ss, CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(BNSTART AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')), CONVERT(DATETIME, GETDATE())) from GNSLACTRLSTATUS where CDSLACONTROL = (select cdslacontrol from wfprocess where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is null and idprocess = wf.idprocess)),0)
          from GNSLACTRLSTATUS where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is not null and CDSLACONTROL = wf.cdslacontrol) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60)), 2)
       else ROUND(( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2)
end >= 100
