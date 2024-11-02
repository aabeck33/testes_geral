Select wf.idprocess, wf.nmprocess, wf.dtstart as StartDectionDt, wf.dtfinish as DtEnd, wf.nmuserstart as Starter
, CASE wf.fgstatus
    WHEN 1 THEN 'In progress'
    WHEN 2 THEN 'Suspended'
    WHEN 3 THEN 'Canceled'
    WHEN 4 THEN 'Closed'
    WHEN 5 THEN 'Locked from editing'
END AS statusproc
, gnrev.NMREVISIONSTATUS as status_DE
, 1 as Qty
, criticidade.tbs002 as Critic, form.tds004 as Investigador, Detection.tbs11 as Detection_Dep, Occurrence.tbs11 as Occurrence_Dep
, InitialC.tbs005 as Initial_Class, FinalC.tbs002 as Final_Class
, DeviationC.tbs006 as Deviation_Category, case form.tds052 WHEN 1 THEN 'Yes' WHEN 2 THEN 'No' end as Deviation_recurrent
, RootC.tbs007 as RootCause, case form.tds039 WHEN 1 THEN 'Yes' WHEN 2 THEN 'No' end as CAPA, case when grid.tbs001 is null THEN 'N/A' ELSE cast (grid.tbs001 as varchar) end as ContributingF
, (SELECT str.DTEXECUTION+str.tmexecution FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113057548' and str.fgstatus = 3 and str.idprocess = wf.idobject) as DtApproval
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113057548' and str.fgstatus = 3 and str.idprocess = wf.idobject and str.idobject = wfa.idobject) as NmApproval

from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
LEFT join DYNtbs007 RootC on form.OIDABCHG0ABCJLN = RootC.oid
LEFT join DYNtbs006 DeviationC on form.OIDABCV3FABC895 = DeviationC.oid
LEFT join DYNtbs002 criticidade on form.OIDABC4SFABC3QP = criticidade.oid
LEFT join DYNtbs011 Detection on form.OIDABC1MOABCE0S = Detection.oid
LEFT join DYNtbs011 Occurrence on form.OIDABCO2WABCQAO = Occurrence.oid
LEFT join DYNtbs005 InitialC on form.OIDABCCM0ABCSBB = InitialC.oid
LEFT join DYNtbs002 FinalC on form.OIDABC4SFABC3QP = FinalC.oid
left join DYNtbs017 grid on grid.OIDABCJVZ44ILEEKJM = form.oid
where wf.cdprocessmodel = 4469
