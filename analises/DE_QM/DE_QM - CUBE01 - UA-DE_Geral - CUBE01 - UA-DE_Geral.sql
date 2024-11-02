Select wf.idProcess, wf.nmUserStart, gnrev.NMREVISIONSTATUS as incStatus, wf.nmProcess
, CASE wf.fgstatus WHEN 1 THEN 'In progress' WHEN 2 THEN 'Postponed' WHEN 3 THEN 'Cancelled' WHEN 4 THEN 'Finished' WHEN 5 THEN 'Blocked for editing' END AS procStatus
, wf.dtStart, wf.dtFinish
, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
WHERE  str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) apprEnabled
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject) as apprPerformed
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
WHERE str.idstruct = 'Decisão141027113714228' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as apprExecutor
, 1 as Qty
from DYNtds010 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
where cdprocessmodel=4469
