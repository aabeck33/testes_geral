select tr.idtrain, tr.nmtrain, tr.DTREALFINISH
, 1 as quantidade
from trtraining tr
where tr.fgstatus = 8 and tr.idtrain like 'TDS-TRE-%'
and tr.idtrain not in (select nmstring from WFPROCATTRIB where cdattribute = 210)
