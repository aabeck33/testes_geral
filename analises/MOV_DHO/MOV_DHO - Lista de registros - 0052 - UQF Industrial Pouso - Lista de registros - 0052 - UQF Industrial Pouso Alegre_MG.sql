Select form.crp008 as unidade, wf.idprocess, wf.nmprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador
, gnrev.NMREVISIONSTATUS as status
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, (select struc.nmstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2) as nmatvatual
--, wfs.nmstruct as nmatvatual
--, case wfa.FGEXECUTORTYPE when 1 then wfa.nmrole when 3 then wfa.nmuser when 4 then wfa.nmuser end as executor
, (select case wfact.FGEXECUTORTYPE when 1 then wfact.nmrole when 3 then wfact.nmuser when 4 then wfact.nmuser end as execut from wfstruct struc inner join wfactivity wfact on struc.idobject = wfact.IDOBJECT where struc.idprocess = wf.idobject and struc.fgstatus = 2) as executor
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura --, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento --, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, 1 as quantidade
from DYNrhcp1 form
inner join GNFORMREG reg on reg.OIDENTITYREG = form.OID
inner join GNFORMREGGROUP grop on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP
inner join WFPROCESS wf on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
--inner join WFSTRUCT wfs on wf.idobject = wfs.idprocess
--inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
where wf.cdprocessmodel=86 and wf.fgstatus < 6
and form.crp008 like '0052%'
