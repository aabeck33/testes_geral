select wf.idobject, wf.idprocess, wf.nmprocess, form.itsm041 as solicitante
, usr.idlogin as iniciador, wfs.idstruct, wfs.nmstruct
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, coalesce(SLALC.QTRESOLUTIONTIME, 0) / 60 as sla
, case when wf.fgstatus = 1 then round(((select coalesce(sum(QTTIMECALENDAR), 0) + coalesce((select datediff(ss, CONVERT(DATETIME, SWITCHOFFSET(CAST(DATEADD(MINUTE, (CAST(BNSTART AS BIGINT) / 1000)/60, '1970-01-01') AS DATETIMEOFFSET),'-03:00')), CONVERT(DATETIME, GETDATE())) from GNSLACTRLSTATUS where CDSLACONTROL = (select cdslacontrol from wfprocess where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is null and idprocess = wf.idprocess)),0)
          from GNSLACTRLSTATUS where (FGTRIGGER = 10 or FGTRIGGER = 20) and qttime is not null and CDSLACONTROL = wf.cdslacontrol) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60)), 2)
       else ROUND(( gnslactrl.QTTIMEFRSTCAL + gnslactrl.QTTIMECAL ) * 100 / (SLALC.QTRESOLUTIONTIME * 60 + 60 ), 2)
end as slapercent
, coordgs.itsm001 as coordresp
, left(depsetor.itsm001, charindex('_', depsetor.itsm001) -1) as depart
, right(depsetor.itsm001, len(depsetor.itsm001) - charindex('_', depsetor.itsm001)) as setor
, usr1.idlogin as exec_user
, gs.idrole as exec_gs
, case when (<!%IDLOGIN%> = adrusrgs.idlogin and wfs.idstruct = 'Atividade2041410270936') then 1 else 2 end comSol
, wfs.dtenabled+wfs.tmenabled as atvhab
, case when (<!%IDLOGIN%> = adrusr.idlogin) then 1 else 2 end meusgs
, 1 as quant_tot
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
inner JOIN GNSLACTRLHISTORY SLAH ON (gnslactrl.CDSLACONTROL = SLAH.CDSLACONTROL AND SLAH.FGCURRENT = 1) 
inner JOIN GNSLALEVEL SLALC ON (SLAH.CDLEVEL = SLALC.CDLEVEL)
inner join aduser usr on usr.cduser = wf.cduserstart
inner join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 2
left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
left join aduser usr1 on usr1.cduser = wfa.cduser
left join adrole gs on gs.cdrole = wfa.cdrole
inner join DYNitsm017 lgs on lgs.itsm001 = case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end
inner join DYNitsm016 coordgs on coordgs.oid = lgs.OIDABCBSAGZNWY2N0Q
inner join DYNitsm020 depsetor on depsetor.oid = coordgs.OIDABCKIK9UXB5HNKT
left join (select usr1.idlogin, adr.cdrole, adr.idrole from aduser usr1
           inner join aduserrole adru on adru.cduser = usr1.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           where adr.cdroleowner = 1404 and usr1.idlogin = <!%IDLOGIN%>) adrusr on  (adrusr.cdrole = wfa.cdrole or (wfa.cdrole is null and adrusr.idrole = form.itsm035))
left join (select usr2.idlogin, adr.idrole from aduser usr2
           inner join aduserrole adru on adru.cduser = usr2.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           where adr.cdroleowner = 1404 and usr2.idlogin = <!%IDLOGIN%>) adrusrgs on adrusrgs.idrole = form.itsm035
where wf.cdprocessmodel = 5251 and wf.fgstatus = 1 and form.itsm035 is not null
