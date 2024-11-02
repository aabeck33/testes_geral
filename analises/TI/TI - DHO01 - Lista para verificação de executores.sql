select _subsql.*, dep.nmdepartment from (
select wf.idprocess, crp001
, (select struc.nmstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2) as nmatvatual
, (select executor from (SELECT HIS.NMUSER as executor
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 
(select struc.idstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2)
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 
(select struc.idstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2)
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  his1.idprocess = wf.idobject
) and HIS.NMUSER is not null) his) as executatvatual
from DYNrhcp1 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where wf.fgstatus in (1,5)
) _subsql
left join aduser usr on usr.nmuser = _subsql.executatvatual
left join aduserdeptpos rel on rel.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
where nmatvatual not in ('Registrar solicitação','Aprovar', 'Aprovar [Ger. área]', 'Aprovar [Dir. área]') and executatvatual is not null
or (crp001 = 4 and nmatvatual = 'Aprovar')
