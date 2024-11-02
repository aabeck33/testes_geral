Select wf.idprocess, wf.NMUSERSTART as iniciador, wf.dtstart as dtabertura
, (SELECT str.DTEXECUTION FROM WFSTRUCT STR
WHERE str.idstruct = 'Atividade15722172718272' and str.idprocess=wf.idobject) as dtexecucao
, substring((select ' | '+ tds013 +' / '+ tds014 as [text()] from DYNtds041 where OIDABCFHvABCauy = form.oid for XML path('')), 4, 4000) as Pl_Ac
, 1 as quantidade
from DYNtds038 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
where wf.cdprocessmodel = 3239 and wf.fgstatus = 4 and gnrev.IDREVISIONSTATUS <> '016' and gnrev.IDREVISIONSTATUS <> '029'
and form.tds003 = 1 and form.tds005 = 2
and exists (select TDS008 from DYNtds041 where OIDABCFHvABCauy = form.oid)
