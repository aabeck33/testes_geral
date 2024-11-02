select wf.idprocess, wf.dtstart+tmstart as dtstart, wf.nmuserstart
, (SELECT str.nmstruct FROM WFSTRUCT STR
   inner join wfactivity wfa on str.idobject = wfa.IDOBJECT
   WHERE str.fgstatus = 2 and wfa.FGACTIVITYTYPE <> 3
   and (str.idprocess = wf.idobject
    or str.idprocess = wf.idobject)
) as atvatual
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
where wf.cdprocessmodel = 5251 and wf.dtstart+tmstart between '2021-04-26 17:30' and '2021-04-27 12:00'
and wf.fgstatus = 1
