Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, case form.tds005 when 1 then 'Alteração de prazo de atividade do processo' when 2 then 'Alteração de prazo de atividade de Plano de Ação' 
                   when 3 then 'Cancelamento de atividade de Plano de Ação' when 4 then 'Adendo' when 5 then 'Cancelamento do Processo' end tpsolicitação
, gnact.idactivity as idatividade, gnact.nmactivity as nmatividade, usrad.nmuser as executor
, unid.tbs001 as unidade, areasol.tbs11 as areasolicitante
, 1 as quantidade
from DYNtds038 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
inner join aduser usr on usr.cduser = wf.CDUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
left join DYNtbs001 unid on unid.oid = form.OIDABC5qIABClq3
left join DYNtbs011 areasol on areasol.oid = form.OIDABChRhABCLwI
left join WFSTRUCT wfs on wf.idobject = wfs.idprocess
inner join wfactivity wfa on wfs.idobject = wfa.IDOBJECT and wfa.FGACTIVITYTYPE=3
inner join gnactivity gnact on gnact.cdgenactivity=wfa.cdgenactivity
inner join gnactivity gnactowner on gnactowner.cdgenactivity = gnact.cdactivityowner
left join aduser usrad on usrad.cduser = gnact.cduser
where wf.cdprocessmodel=72 and form.tds003 = 2
