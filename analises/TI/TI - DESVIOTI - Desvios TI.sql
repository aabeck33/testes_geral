select idprocess, nmprocess, dtstart, status, quantidade
from (Select wf.idprocess, wf.nmprocess, wf.dtstart, wf.cdassocreg
      , case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status
      , wf.idobject
      , 1 as quantidade
      From wfprocess wf
      where (wf.cdprocessmodel = 17 or wf.cdprocessmodel = 3235 or wf.cdprocessmodel = 4469)) _sub
inner join gnassocformreg gnf on (_sub.cdassocreg = gnf.cdassoc)
inner join DYNtds010 form on (gnf.oidentityreg = form.oid)
where exists (select 1
              from DYNtbs011 areaocor
              where areaocor.oid = form.OIDABCO2wABCqaO and (areaocor.tbs11 = 'TECNOLOGIA DA INFORMAÇÃO' or areaocor.tbs11 = 'Computer Systems' or areaocor.tbs11 = 'TI')
) or
exists (select 1
        from aduser usr
        inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1
        inner join addepartment dep on dep.cddepartment = rel.cddepartment and (dep.nmdepartment = 'Tecnologia da Informação' or dep.nmdepartment = 'Information Technology')
        where usr.iduser = form.tds005
) or
exists (SELECT 1
        FROM WFSTRUCT STR, WFHISTORY HIS
        inner join aduserdeptpos rel on rel.cduser = his.cduser and rel.FGDEFAULTDEPTPOS = 1
        inner join addepartment dep on dep.cddepartment = rel.cddepartment
        WHERE  str.idstruct = 'Atividade141027113146417' and str.idprocess=_sub.idobject
        and HIS.IDSTRUCT = STR.IDOBJECT and his.idprocess = _sub.idobject and HIS.FGTYPE = 9
        and (dep.nmdepartment = 'Tecnologia da Informação' or dep.nmdepartment = 'Information Technology')
) or
exists (SELECT 1 
        FROM WFSTRUCT STR, WFACTIVITY WFA
        inner join aduserdeptpos rel on rel.cduser = wfa.cduser and rel.FGDEFAULTDEPTPOS = 1
        inner join addepartment dep on dep.cddepartment = rel.cddepartment
        WHERE str.idstruct = 'Atividade141027113146417' and str.idprocess = _sub.idobject and str.idobject = wfa.idobject
        and (dep.nmdepartment = 'Tecnologia da Informação' or dep.nmdepartment = 'Information Technology')
)
