select wf.idprocess, wf.nmprocess, form.itsm003 as respTec
, form.itsm020 as dtIniP, CONVERT(VARCHAR(19), DATEADD(second, DATEDIFF(second, GETUTCDATE(), GETDATE()), DATEADD(S, form.itsm022, '1970-01-01')), 108) as tmIniP
, form.itsm021 as dtFimP, CONVERT(VARCHAR(19), DATEADD(second, DATEDIFF(second, GETUTCDATE(), GETDATE()), DATEADD(S, form.itsm023, '1970-01-01')), 108) as tmFimP
, form.itsm027 as dtIniR, CONVERT(VARCHAR(19), DATEADD(second, DATEDIFF(second, GETUTCDATE(), GETDATE()), DATEADD(S, form.itsm029, '1970-01-01')), 108) as tmIniR
, form.itsm028 as dtFimR, CONVERT(VARCHAR(19), DATEADD(second, DATEDIFF(second, GETUTCDATE(), GETDATE()), DATEADD(S, form.itsm030, '1970-01-01')), 108) as tmFimR
, wfs.fgstatus
from DYNitsm015 form
inner join gnassocformreg gnf on gnf.oidentityreg = form.oid
inner join wfprocess wf on wf.cdassocreg = gnf.cdassoc
inner join wfstruct wfs on wfs.idprocess = wf.idobject and wfs.idstruct = 'Atividade20111012624715'
where wf.cdprocessmodel = 5679
