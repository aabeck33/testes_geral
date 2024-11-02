select atb.nmlabel, atv.nmattribute
from adattribvalue atv
inner join adattribute atb on atb.cdattribute = atv.cdattribute
where atv.CDATTRIBUTE in (select CDATTRIBUTE from adattribute where nmlabel like 'ÁREAS DE ABRANGÊNCIA CORPORATIVAS' or nmlabel like 'ÁREAS RESPONSÁVEIS CORPORATIVAS')

