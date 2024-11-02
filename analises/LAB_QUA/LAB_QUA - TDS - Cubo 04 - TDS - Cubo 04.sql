Select wf.idprocess, wf.nmprocess, gnrev.NMREVISIONSTATUS as status, wf.NMUSERSTART as iniciador
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, areamud.tbs001 as areamudanca
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para ediçao' end statusprocesso
/*
, HIS.NMUSER, HIS.NMACTION
, format(HIS.DTHISTORY,'dd/MM/yyyy') as dtexecucao, datepart(yyyy,HIS.DTHISTORY) as dtexecucao_ano, datepart(MM,HIS.DTHISTORY) as dtexecucao_mes
, format(str.DTESTIMATEDFINISH,'dd/MM/yyyy') as dtprazo, datepart(yyyy,str.DTESTIMATEDFINISH) as dtprazo_ano, datepart(MM,str.DTESTIMATEDFINISH) as dtprazo_mes
*/
, coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs019 where OIDABCJonABCFKa = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as listamudanca --listamudanca--
, coalesce((select substring((select ' | '+ wfassoc.idprocess as [text()] from wfprocess wfp
inner JOIN gnactivity gnactp ON wfp.CDGENACTIVITY = gnactp.CDGENACTIVITY
inner join GNASSOCWORKFLOW workf on workf.cdassoc = gnactp.cdassoc
inner join wfprocess wfassoc on wfassoc.idobject = workf.idprocess
where wfp.idobject = wf.idobject FOR XML PATH('')), 4, 1000)), 'NA') as listaprocassoc --listaprocessos--
, 1 as quantidade
from DYNtbs015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join WFHISTORY HIS on (HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject))
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
left join DYNtbs039 areamud on areamud.oid = form.OIDABCQueABCNDM
where wf.cdprocessmodel in (1) and wf.CDUSERSTART in (select rel.cduser from aduserdeptpos rel where cddepartment = 94)
--HIS.CDUSER in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
union
Select wf.idprocess, wf.nmprocess, gnrev.NMREVISIONSTATUS as status, wf.NMUSERSTART as iniciador
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, areamud.tbs001 as areamudanca
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para ediçao' end statusprocesso
/*
, HIS.NMUSER, HIS.NMACTION
, format(HIS.DTHISTORY,'dd/MM/yyyy') as dtexecucao, datepart(yyyy,HIS.DTHISTORY) as dtexecucao_ano, datepart(MM,HIS.DTHISTORY) as dtexecucao_mes
, format(str.DTESTIMATEDFINISH,'dd/MM/yyyy') as dtprazo, datepart(yyyy,str.DTESTIMATEDFINISH) as dtprazo_ano, datepart(MM,str.DTESTIMATEDFINISH) as dtprazo_mes
*/
, (select substring((
select ' | '+ substring((select nmlabel from EMATTRMODEL where oidentity = (select oid from EMENTITYMODEL where idname = 'tds015') and idname=coluna),10,250) as [text()]
from (select * from dyntds015 where OID = form.oid) s
unpivot (valor for coluna in (tds027, tds028, tds029, tds030, tds031, tds032, tds033, tds034, tds035, tds036, tds037, tds038, tds039, tds040, tds041, tds042, tds043, tds044, tds045, tds046, tds047, tds048, tds049, tds050, tds051, tds052, tds053, tds054, tds055, tds056, tds057, tds058, tds059, tds060, tds061, tds062, tds063, tds064, tds065, tds066, tds104)) as tt
where valor = 1 FOR XML PATH('')), 4, 1000)) as listamudanca
, coalesce((select substring((select ' | '+ wfassoc.idprocess as [text()] from wfprocess wfp
inner JOIN gnactivity gnactp ON wfp.CDGENACTIVITY = gnactp.CDGENACTIVITY
inner join GNASSOCWORKFLOW workf on workf.cdassoc = gnactp.cdassoc
inner join wfprocess wfassoc on wfassoc.idobject = workf.idprocess
where wfp.idobject = wf.idobject FOR XML PATH('')), 4, 1000)), 'NA') as listaprocassoc --listaprocessos--
, 1 as quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join WFHISTORY HIS on (HIS.FGTYPE IN (9) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (9) and his1.idprocess = wf.idobject))
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
left join DYNtbs039 areamud on areamud.oid = form.OIDABCk8DABCghk
where wf.cdprocessmodel in (1) and wf.CDUSERSTART in (select rel.cduser from aduserdeptpos rel where cddepartment in (94,162))
