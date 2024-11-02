Select wf.idprocess, wf.nmprocess, wf.dtstart, wf.dtfinish
, CASE wf.fgstatus
    WHEN 1 THEN 'In progress'
    WHEN 2 THEN 'Suspended'
    WHEN 3 THEN 'Canceled'
    WHEN 4 THEN 'Closed'
    WHEN 5 THEN 'Locked from editing'
END AS statusproc
, gnrev.NMREVISIONSTATUS as status
, 1 as Qty
, CASE form.TDS031
    WHEN 1 THEN 'Critical'
    WHEN 2 THEN 'Not Critical'
END AS CRITICI
, cateven.tbs001 as category
, laboccu.tbs001 as labofoccurence
, form.tds009 as method_numb

, cast(coalesce((select substring((select ' | '+ equipo.tds001 as [text()] from DYNtds016 form1
                 left join DYNtds050 equipo on form1.oid = equipo.OIDABC60YRMLCRJSBK
                 where form1.oid = form.oid
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listaequipamentos
, rootc.tbs007 as RootCause
, form.tds028 as recur
from DYNtds016 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join DYNtbs025 cateven on cateven.oid = form.OIDABCDVEABCIRD
inner join DYNtbs026 laboccu on laboccu.oid = form.OIDABCISOABCQAE
inner join DYNtbs007 rootc on rootc.oid = form.OIDABCV7YABC5WQ


where wf.cdprocessmodel = 4471
