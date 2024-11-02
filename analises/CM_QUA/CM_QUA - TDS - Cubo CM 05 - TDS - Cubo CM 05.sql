Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, wfs.nmstruct, case wfs.FGCONCLUDEDSTATUS when 1 then 'Finalizada em dia' when 2 then 'Finalizada em atraso' else 'NA' end statusencerramento
, datediff(dd, (cast(dtenabled as datetime) + cast(tmenabled as datetime)), (cast(dtexecution as datetime) + cast(tmexecution as datetime))) as tpexec
, 1 as Quantidade
from WFPROCESS wf
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
inner join WFSTRUCT wfs on wf.idobject = wfs.idprocess
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE<>3
where cdprocessmodel=1 and wfs.FGCONCLUDEDSTATUS is not null
