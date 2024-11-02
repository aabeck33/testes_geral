Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, gnact.nmactivity
, case gnact.fgstatus
    when 5 then 'Executada'
    when 3 then 'Pendente'
  end as status
, case
    when gnact.fgexecutertype= 1 then (select nmuser from aduser where cduser = gnact.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is not null
      then (select nmuser from aduser where cduser = wfa.cduser)
    when gnact.fgexecutertype=6 and (select nmuser from aduser where cduser = wfa.cduser) is null
      then (select nmrole from adrole where cdrole = gnact.cdrole)
    else 'n/a'
  end as executor
, gnactowner.nmactivity as nmactowner
, (select format(exeadhoc.dthistory,'dd/MM/yyyy') from (SELECT top 1 HIS.NMUSER, HIS.DTHISTORY, HIS.TMHISTORY
FROM WFHISTORY HIS
Where HIS.IDSTRUCT = wfs.IDOBJECT
AND HIS.FGTYPE IN (9,11)
ORDER   BY HIS.DTHISTORY, HIS.TMHISTORY) exeadhoc) as dtexec
, 1 as Quantidade
from WFPROCESS wf
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join WFSTRUCT wfs on wf.idobject = wfs.idprocess
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
inner join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
inner join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
where cdprocessmodel=1 and wfs.FGCONCLUDEDSTATUS is not null
