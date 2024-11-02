select usr.nmuser, cou.nmcourse, case treusr.fgpend when 2 then 'Executado' else 'Pendente' end Status
, format(treusr.dtpendres,'dd/MM/yyyy') as dtexecut
, datepart(yyyy,treusr.dtpendres) as dtexecut_ano, datepart(MM,treusr.dtpendres) as dtexecut_mes
, treusr.dtpendres as dtexecutado
, 1 as Quantidade
from trtrainuser treusr
inner join trtraining tre on tre.cdtrain = treusr.cdtrain
inner join trcourse cou on cou.cdcourse = tre.cdcourse and cou.cdcoursetype=46
inner join aduser usr on usr.cduser = treusr.cduser and usr.fguserenabled = 1 and (usr.cdleader = 4296 or usr.cduser = 4296)
where tre.fgstatus = 8
