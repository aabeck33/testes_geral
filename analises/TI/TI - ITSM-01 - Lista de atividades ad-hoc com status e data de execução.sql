select wfp.idprocess, gnactowner.nmactivity as nmactowner, wfao.nmuser as exe_owner, gnact.nmactivity, wfa.nmuser as exe_adh
, case gnact.fgstatus
    when 3 then 'Em execução'
    when 5 then 'Finalizada'
    else 'Indefinido'
end status
, (select exeadhoc.dthistory + exeadhoc.tmhistory from (SELECT top 1 HIS.DTHISTORY, HIS.TMHISTORY
    FROM WFHISTORY HIS
    Where HIS.IDSTRUCT = wfs.IDOBJECT
    AND HIS.FGTYPE IN (9)
    ORDER BY HIS.DTHISTORY, HIS.TMHISTORY) exeadhoc) as dtexec
from wfactivity wfa
inner join WFSTRUCT wfs on wfs.idobject = wfa.IDOBJECT
inner join WFPROCESS wfp on wfp.idobject = wfs.idprocess
inner join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
inner join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
inner join wfactivity wfao on gnactowner.cdgenactivity=wfao.cdgenactivity
inner join aduser usr on usr.cduser = wfao.cduser
where wfa.FGACTIVITYTYPE=3 and wfp.cdprocessmodel in (5251, 5470, 5692, 5679)
