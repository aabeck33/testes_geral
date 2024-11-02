select distinct *
from (
select wf.idprocess, wf.nmprocess, form.itsm066 as gruposolucionador, substring(wfs.NMROLE, 20, case when charindex(' N', substring(wfs.NMROLE, 20,50))-1 <1 then 1 else charindex(' N', substring(wfs.NMROLE, 20,50))-1 end) as GSMUD
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, case when (docs.iddocument is null and wf.fgstatus = 1) then 'Não iniciado'
	   when ((docs.iddocument like 'APL-DE-%' or docs.iddocument like 'SAP-DE-%') and wf.fgstatus = 1) then 'Em andamento'
		when (exists (select 1
                    FROM WFSTRUCT wfs, WFHISTORY HIS
                    WHERE wfs.idstruct = 'Atividade20111012624715' and wfs.idprocess = wf.idobject
                    and HIS.IDSTRUCT = wfs.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and his.nmaction = 'Submeter / Submit') and wf.fgstatus = 1) then 'Entregue'
       when wf.fgstatus = 2 then 'Suspenso'
       when wf.fgstatus = 3 then 'Cancelado'
       when wf.fgstatus = 4 then 'Finalizado'
end Status2
, form.itsm041, form.itsm048, form.itsm040, cast(form.itsm034 as varchar(max)) as itsm034, usr.idlogin
, case when (<!%IDLOGIN%> = adrusr.idlogin) then 1 else 2 end meusgs
, case when (<!%IDLOGIN%> = adrcoord.coord) then 1 else 2 end eucoord, adrcoord.coord
, form.itsm035 as GS, case when (form.itsm035 = '' or form.itsm035 is null) then 'N/A' else substring(form.itsm035, 1, coalesce(charindex('_', form.itsm035)-1, len(form.itsm035))) end as GSB
, wfs.idstruct, wfs.nmstruct, wf.dtfinish
, 1 as quant
, kanban.*
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left join aduser usr on usr.nmuser = form.itsm041
left join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 2
left join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
left join (select idt.idtask, tst.nmtitle as nmkanban, substring(tst.nmtitle, 1, case when charindex(' ', tst.nmtitle) < 1 then 1 else charindex(' ', tst.nmtitle) end -1) as chave, sprint.nmtitle as nmsprint, flow.nmflow, step.nmstep
		   , lane.nmtitle as nmlane, tasktype.nmtasktype, tst.vlestimate, tst.dtstartplan, tst.dtdeadline, wor.nmprefix, wor.nmworkspace, val.nmattribute
		   from tstask tst 
		   inner join TSWORKSPACECHANGESHISTORY idt on tst.cdtask = idt.cdtask 
		   inner join TSLANESTEP steplane on steplane.cdstep = tst.cdstep and steplane.cdworkspace = tst.cdworkspace 
		   inner join TSTASKTYPE tasktype on tasktype.cdtasktype = tst.cdtasktype 
		   left join wfprocess wfk on wfk.idobject = tst.idobject
		   left join wfprocattrib dep on dep.idprocess = wfk.idobject and dep.cdattribute = 761
		   left join adattribvalue val on val.cdattribute = dep.cdattribute and val.cdvalue = dep.cdvalue
		   left join tslane lane on lane.cdlane = steplane.cdlane and lane.cdworkspace = tst.cdworkspace
		   left join TSSPRINT sprint on sprint.cdsprint = tst.cdsprint and sprint.cdworkspace = tst.cdworkspace
		   left join tsflow flow on flow.cdflow = tst.cdflow 
		   left join tsstep step on step.cdstep = tst.cdstep
		   left join tsworkspace wor on wor.cdworkspace = tst.cdworkspace) kanban on kanban.chave = wf.idprocess
left join (
            select wfs.idprocess, rev.iddocument, att.VLVALUE, rev.cddocument, rev.cdrevision
            from wfstruct wfs
            inner join wfprocdocument wfdoc on wfdoc.idstruct = wfs.idobject
            inner join dcdocrevision rev on rev.cddocument = wfdoc.cddocument and (rev.cdrevision = wfdoc.cddocumentrevis or (wfdoc.cddocumentrevis is null and rev.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)))
            inner join dcdocumentattrib att on att.cdrevision = rev.cdrevision and att.cdattribute = 235 and att.cdrevision = rev.cdrevision
            where (rev.iddocument like 'APL-DE-%' or rev.iddocument like 'SAP-DE-%')
) docs on docs.idprocess = wf.idobject
left join (select usr1.idlogin, adr.cdrole, adr.idrole from aduser usr1
           inner join aduserrole adru on adru.cduser = usr1.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           where adr.cdroleowner = 1404 and usr1.idlogin = <!%IDLOGIN%>) adrusr on  (adrusr.cdrole = wfa.cdrole or (wfa.cdrole is null and adrusr.idrole = form.itsm035))
left join (select usr1.idlogin, adr.cdrole, adr.idrole, coord.ITSM002 as coord from aduser usr1
           inner join aduserrole adru on adru.cduser = usr1.cduser
           inner join adrole adr on adr.cdrole = adru.cdrole
           inner join DYNitsm017 lgs on lgs.itsm001 = case when charindex('_', adr.idrole) < 1 then 'null' else left(adr.idrole, charindex('_', adr.idrole)-1) end
           inner join DYNitsm016 coord on lgs.OIDABCBSAGZNWY2N0Q = coord.oid
           where adr.cdroleowner = 1404 and coord.ITSM002 = <!%IDLOGIN%>) adrcoord on (adrcoord.cdrole = wfa.cdrole or (wfa.cdrole is null and adrcoord.idrole = form.itsm035))
where wf.cdprocessmodel = 5679 and form.itsm035 is not null and (wf.dtfinish is null or datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate()) or (datepart(yyyy, wf.dtfinish) = datepart(yyyy, getdate())-1 and datepart(mm, wf.dtfinish) = 12))
) sub
where status2 is not null
