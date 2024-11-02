Select wf.idprocess as Código, gnrev.NMREVISIONSTATUS as Status, wf.nmprocess as Título
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, wf.dtstart, struc.nmstruct as nmatvatual, struc.dtenabled as dtiniatvatual
, struc.dtestimatedfinish as przatvatual
, form.con118 as RC_Aprovada_SAP, form.con014 as Gestor_do_Contrato, form.con012 as Departamento, form.con045 as Especie_Contrato, form.con078 as Data_prev_ini_prestServ, form.con039 as Gerente_Aprovador
, form.con019 as Objeto_Contrato
, case when wfA.NMUSER is null then (select nmrole from adrole where cdrole = wfa.cdrole) else WFA.NMUSER end as executatvatual
, coalesce((select dep1.iddepartment +' - '+ dep1.nmdepartment
            from aduser usr1
            inner join aduserdeptpos rel1 on rel1.cduser = usr1.cduser and rel1.fgdefaultdeptpos = 1
            inner join addepartment dep1 on dep1.cddepartment = rel1.cddepartment
            where usr1.cduser = WFA.cdUSER), (select nmrole from adrole where cdrole = wfa.cdrole)) as executarea
, case when wf.cdprocessmodel <> 2951 then combo1.con001 else 'Distrato' end as tipocontr
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNcon001espec combo1 on combo1.oid = form.OIDABCzgOABC2Ih
inner JOIN WFSTRUCT struc ON struc.idprocess = wf.idobject and struc.fgstatus = 2
inner join wfactivity wfa on struc.idobject = wfa.IDOBJECT
where wf.cdprocessmodel in (2808, 2909, 2951) and wf.fgstatus = 1
