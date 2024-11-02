SELECT wf2.idprocess as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
--Subprocessos
from wfstruct wfs
inner join WFSUBPROCESS wfsub on wfsub.IDOBJECT = wfs.IDOBJECT
inner join wfprocess wf on wfs.idprocess = wf.idobject
inner join wfprocess wf2 on wf2.idobject = wfsub.IDSUBPROCESS
where wfsub.CDPROCESSMODEL in (5251, 5470, 5692, 5679,5716)
--Workflow
union all
SELECT wf.idprocess as filho, p.idprocess as pai, p.fgstatus, p.nmprocessmodel, p.nmprocess, p.nmuserstart, p.fgconcludedstatus
FROM gnassocworkflow bidirect 
INNER JOIN gnassoc gnas ON bidirect.cdassoc = gnas.cdassoc AND gnas.nrobjectparent IN ( 99207887 ) 
LEFT OUTER JOIN gnactivity gnac ON gnas.cdassoc = gnac.cdassoc 
INNER JOIN wfprocess p ON p.cdgenactivity = gnac.cdgenactivity 
INNER JOIN pmactivity pmact ON (pmact.cdactivity = p.cdprocessmodel) 
left join wfprocess wf on wf.idobject = bidirect.idprocess and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
WHERE p.idobject IS NOT NULL AND ( p.cdprodautomation NOT IN( 160, 202 ))
and p.cdprocessmodel in (5251,5470,5692,5679,5716)
--Problema
union all
SELECT wf.idprocess as filho, p.idprocess as pai, p.fgstatus, p.nmprocessmodel, p.nmprocess, p.nmuserstart, p.fgconcludedstatus
FROM gnassocworkflow bidirect 
INNER JOIN gnassoc gnas ON bidirect.cdassoc = gnas.cdassoc AND gnas.nrobjectparent IN ( 99207887 ) 
LEFT OUTER JOIN gnactivity gnac ON gnas.cdassoc = gnac.cdassoc 
INNER JOIN wfprocess p ON p.cdgenactivity = gnac.cdgenactivity 
INNER JOIN inoccurrence incid ON ( p.idobject = incid.idworkflow ) 
INNER JOIN gngentype gnt ON incid.cdoccurrencetype = gnt.cdgentype 
LEFT OUTER JOIN gnrevisionstatus gnrs ON ( incid.cdstatus = gnrs.cdrevisionstatus ) 
left join wfprocess wf on wf.idobject = bidirect.idprocess and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
WHERE p.idobject IS NOT NULL AND ( p.cdprodautomation IN( 202 ) AND p.cdprodautomation IS NOT NULL )
and p.cdprocessmodel in (5251,5470,5692,5679,5716)
--Incidente
union all
SELECT wf.idprocess as filho, p.idprocess as pai, p.fgstatus, p.nmprocessmodel, p.nmprocess, p.nmuserstart, p.fgconcludedstatus
FROM gnassocworkflow bidirect 
INNER JOIN gnassoc gnas ON bidirect.cdassoc = gnas.cdassoc AND gnas.nrobjectparent IN ( 99207887 ) 
LEFT OUTER JOIN gnactivity gnac ON gnas.cdassoc = gnac.cdassoc 
INNER JOIN wfprocess p ON p.cdgenactivity = gnac.cdgenactivity 
INNER JOIN inoccurrence incid ON ( p.idobject = incid.idworkflow ) 
INNER JOIN gngentype gnt ON incid.cdoccurrencetype = gnt.cdgentype 
LEFT OUTER JOIN gnrevisionstatus gnrs ON ( incid.cdstatus = gnrs.cdrevisionstatus ) 
left join wfprocess wf on wf.idobject = bidirect.idprocess and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
WHERE p.idobject IS NOT NULL AND ( p.cdprodautomation IN( 160 ) AND p.cdprodautomation IS NOT NULL )
and p.cdprocessmodel in (5251,5470,5692,5679,5716)
--Documento
union all
SELECT dr.iddocument +'/'+ gr.idrevision as filho, wfproc.idprocess as pai, wfproc.fgstatus, wfproc.nmprocessmodel, wfproc.nmprocess, wfproc.nmuserstart, wfproc.fgconcludedstatus
FROM dcdocrevision dr 
INNER JOIN dcdocument dc ON dc.cddocument = dr.cddocument 
INNER JOIN gnrevision gr ON gr.cdrevision = dr.cdrevision 
INNER JOIN wfprocdocument wfdoc ON dr.cddocument = wfdoc.cddocument AND (dr.cdrevision = wfdoc.cddocumentrevis OR (wfdoc.cddocumentrevis IS NULL AND dr.fgcurrent = 1)) 
INNER JOIN wfstruct wfs ON wfdoc.idstruct = wfs.idobject 
INNER JOIN wfprocess wfproc ON wfs.idprocess = wfproc.idobject 
WHERE  wfproc.cdprocessmodel in (5251,5470,5692,5679,5716)
--Plano de ação
union all
SELECT gnact.idactivity as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM wfprocess wf
inner JOIN GNACTIVITY GNP ON (wf.CDGENACTIVITY = GNP.CDGENACTIVITY)
inner join gnassocactionplan stpl on stpl.cdassoc = GNP.CDASSOC
inner JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan 
INNER JOIN gntmcactionplan gntmc ON gntmc.cdgenactivity = stpl.cdactionplan 
INNER JOIN gnactivity gnact ON gntmc.cdgenactivity = gnact.cdgenactivity 
WHERE wf.cdprocessmodel in (5251,5470,5692,5679,5716)
--Ad-Hoc
union all
SELECT gnact.idactivity as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
from wfactivity wfa 
inner join WFSTRUCT wfs on wfs.idobject = wfa.IDOBJECT 
inner join WFPROCESS wf on wf.idobject = wfs.idprocess 
inner join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity 
inner join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner 
where wfa.FGACTIVITYTYPE = 3 and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
--Ativos
union all
SELECT obj.idobject as filho, prc.idprocess as pai, prc.fgstatus, prc.nmprocessmodel, prc.nmprocess, prc.nmuserstart, prc.fgconcludedstatus
FROM gnassocasset sptb
inner JOIN obobject obj ON (obj.cdobject = sptb.cdasset AND obj.cdrevision = sptb.cdassetrevision)
inner join GNACTIVITY GNP ON gnp.cdassoc = sptb.cdassoc
inner join wfprocess prc on (PRC.CDGENACTIVITY = GNP.CDGENACTIVITY)
INNER JOIN asasset ass ON (ass.cdasset = obj.cdobject AND ass.cdrevision = obj.cdrevision) 
INNER JOIN gnassoc gnas ON gnp.cdassoc = gnas.cdassoc AND gnas.nrobjectparent IN ( 99207887 )
LEFT OUTER JOIN gnrevision gn ON (gn.cdassoc = gnas.cdassoc)
where prc.cdprocessmodel in (5251,5470,5692,5679,5716)
--Projeto
union all
SELECT ab.nmidtask as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM   prtasktype prtt,addepartment depart,prpriority priori,prtask ab,
       prtaskwfprocess
       prwf
inner join wfprocess wf on wf.idobject = prwf.idprocess
WHERE  ab.fgtasktype = 1
       AND prtt.cdtasktype = ab.cdtasktype
       AND depart.cddepartment = ab.cdtaskdept
       AND priori.cdpriority = ab.cdpriority
       AND ab.cdbasetask = ab.cdtask
       AND ab.cdtask = prwf.cdtask
and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
--Atividade de projeto
union all
SELECT ab.nmidtask +'/'+ ati.nmidtask as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM   prtask ati,prtask ab,prtaskwfprocess prwf 
inner join wfprocess wf on wf.idobject = prwf.idprocess
WHERE  ati.cdtask = ab.cdtask 
       AND ati.fgtasktype = 3 
       AND ab.cdbasetask = ab.cdtask 
       AND ati.cdtask = prwf.cdtask 
and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
  UNION all
SELECT ab.nmidtask +'/'+ ati.nmidtask as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM   prtask ati,prtask ab,prtaskwfprocess prwf
inner join wfprocess wf on wf.idobject = prwf.idprocess
WHERE  ati.fgtasktype = 1 
       AND ati.cdbasetask <> ati.cdtask 
       AND ati.cdbasetask = ab.cdtask 
       AND ati.cdtask = prwf.cdtask 
and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
--Anexos
union all
SELECT adattch.nmattachment as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM  wfprocattachment wfp, adattachment adattch, wfprocess wf
WHERE adattch.cdattachment = wfp.cdattachment and wf.idobject = wfp.idprocess
and wf.cdprocessmodel in (5251,5470,5692,5679,5716)
AND wfp.cduser IS NOT NULL
--Análises e suas causas
union all
SELECT gna.idanalisys +'/'+ pb.nmcause as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
FROM gnstruct gns 
LEFT OUTER JOIN addepartment ada ON gns.cddeptrespcause = ada.cddepartment 
LEFT OUTER JOIN gnanalisys gna ON gna.cdanalisys = gns.cdanalisys 
INNER JOIN pbstructcause pb ON gns.cdstruct = pb.cdstruct 
LEFT OUTER JOIN obcause ob ON ob.cdcause = pb.cdcause 
inner join pbproblem pbp on (gns.cdtoolanalysis = pbp.CDTOOLSANALISYS)
INNER JOIN INOCCURRENCE INC ON (inc.cdoccurrence = pbp.cdoccurrence)
inner join wfprocess wf on (wf.IDOBJECT = INC.IDWORKFLOW)
WHERE wf.cdprocessmodel in (5251,5470,5692,5679,5716)
--Checklists
union all
SELECT wfs.idstruct as filho, wf.idprocess as pai, wf.fgstatus, wf.nmprocessmodel, wf.nmprocess, wf.nmuserstart, wf.fgconcludedstatus
from WFSTRUCT wfs
inner join WFPROCESS wf on wf.idobject = wfs.idprocess
where wf.cdprocessmodel in (5251,5470,5692,5679,5716) and wfs.IDOBJECT in ( 
		select wfs.IDOBJECT 
		from WFSTRUCT wfs, WFACTIVITY wfa, WFACTCHECKLIST wfc, WFPROCESS wfp
		where wfs.IDOBJECT = wfa.IDOBJECT and wfs.IDOBJECT = wfc.IDACTIVITY and wfp.idobject = wfs.idprocess
		and wfp.cdprocessmodel in (5251,5470,5692,5679,5716)
)
