Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, gnactp.idactivity as idplano, usrp.nmuser as planejador
, 1 as Quantidade
from WFPROCESS wf
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
inner join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
inner JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
inner JOIN gnactivity gnactp ON gnpl.cdgenactivity = gnactp.cdgenactivity
inner join aduser usrp on usrp.cduser = gnactp.cduser
where cdprocessmodel=1
