select forms.itsm001, forms.itsm002p as objeto, forms.itsm003p as servico, forms.itsm004p as compl, forms.itsm021, forms.itsm006
, avg((QTSLATOTALTIMECAL - QTSLAPAUSETIMECAL + 60) / 3600) as worktime_horas
, case forms.itsm007
    when 1 then 'Solicitação'
    when 2 then 'Incidente'
    when 3 then 'Mudança'
    when 4 then 'Projeto'
    when 5 then 'Problema'
    when 6 then 'Evento'
end as tipo
, count(wf.idprocess) as qtchamados
from wfprocess wf
inner join gnassocformreg gnf on (wf.cdassocreg = gnf.cdassoc)
inner join DYNitsm form on (gnf.oidentityreg = form.oid)
inner join DYNitsm001 forms on forms.itsm001 = form.itsm006
inner join GNSLACONTROL gnslactrl on gnslactrl.CDSLACONTROL = wf.CDSLACONTROL
where cdprocessmodel=5251 and wf.fgstatus = 4 and forms.itsm033 <> 1
group by forms.itsm001, forms.itsm002p, forms.itsm003p, forms.itsm004p, forms.itsm021, forms.itsm006, forms.itsm007
union all
select serv.itsm001, serv.itsm002p as objeto, serv.itsm003p as servico, serv.itsm004p as compl, serv.itsm021, serv.itsm006, null as worktime_horas
, case serv.itsm007
when 1 then 'Solicitação'
when 2 then 'Incidente'
when 3 then 'Mudança'
when 4 then 'Projeto'
when 5 then 'Problema'
when 6 then 'Evento'
end as tipo
, 0 as qtchamados
from DYNitsm001 serv
where not exists (select 1 from DYNitsm tick where tick.itsm006 = serv.itsm001)
