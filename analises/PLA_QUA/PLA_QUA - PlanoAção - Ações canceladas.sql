select plano.idactivity as plano, gnact.idactivity, gnact.nmactivity, gnact.nmuserupd
, format(gnstatus.DTSTACTION,'dd/MM/yyyy') as DTSTACTION, gnstatus.dsreason
from gnactivity gnact
inner join GNACTIVITYSTATUS gnstatus on gnstatus.cdgenactivity = gnact.cdgenactivity and gnstatus.dsreason is not null and gnstatus.fgaction=1 and nrseqstatus = (select max(gnstatus1.nrseqstatus) from GNACTIVITYSTATUS gnstatus1 where gnstatus1.cdgenactivity = gnstatus.cdgenactivity)
inner join gnactivity plano on plano.cdgenactivity = gnact.cdactivityowner
where gnact.cdisosystem = 174 
