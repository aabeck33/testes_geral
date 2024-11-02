select *
, case status when 'Em renovação' then 1 else 0 end qrenovando
, case status when 'Á Vencer' then 1 else 0 end qavencer
from (
select cat.nmcategory as Categoria, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case when (rev.fgcurrent = 2) and (doc.fgstatus = 2) then 'Obsoleto' 
       when (doc.fgstatus = 7) then 'Encerrado'
       when (doc.fgstatus = 4) then 'Cancelado'
       when (doc.fgstatus = 1) then 'Emitindo'
       when ((rev.fgcurrent = 1) and (doc.fgstatus = 2) and (gnrev.dtvalidity - getdate()) > 0 or
             (rev.fgcurrent = 1) and (doc.fgstatus = 2) and (gnrev.dtvalidity - getdate()) <= 0) then 'Á Vencer'
       when (rev.fgcurrent = 1) and (doc.fgstatus = 2) and (gnrev.dtvalidity is null) then 'N/A'
       when (doc.fgstatus = 3) then 'Em renovação'
else 'N/A'
end as status
, coalesce((select form.con026 from DYNcon001 form
   inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
   inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
   INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
   where wf.idprocess = ((select nmvalue from dcdocumentattrib where cdrevision = rev.cdrevision and ((cdattribute = 230 or cdattribute = 231) and nmvalue is not null)))), 0) as valor
, coalesce((select form.con077 from DYNcon001 form
   inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
   inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
   INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
   where wf.idprocess = ((select nmvalue from dcdocumentattrib where cdrevision = rev.cdrevision and ((cdattribute = 230 or cdattribute = 231) and nmvalue is not null)))), 0) as vmensal
, gnrev.dtvalidity as dtvalid
, coalesce((select nmvalue from dcdocumentattrib where cdrevision = rev.cdrevision and ((cdattribute = 230 or cdattribute = 231) and nmvalue is not null)),'N/A') as procassoc
, (select atvl.nmvalue from dcdocumentattrib atvl where atvl.cdattribute = 349 and atvl.cdrevision = rev.cdrevision) as depsol
, coalesce((select meses.con002
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join DYNcon001meses meses on meses.oid = form.OIDABC9E1L03VLGM5R
where wf.idprocess = (select nmvalue from dcdocumentattrib where cdrevision = rev.cdrevision and ((cdattribute = 230 or cdattribute = 231) and nmvalue is not null))), 'N/A') as mesreaj
, 1 as quantidade
from dcdocrevision rev
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dcdocument doc on rev.cddocument = doc.cddocument
where rev.cdcategory in (select cdcategory from dccategory where idcategory in ('jurcont', 'jurcontconf'))
and (((rev.fgcurrent <> 2) and (doc.fgstatus <> 1)) or ((rev.fgcurrent <> 2) and (doc.fgstatus <> 3))) and doc.fgstatus <> 4 and doc.fgstatus <> 7
and (gnrev.dtvalidity between getdate() and dateadd(month,12,getdate())
or datepart(year,gnrev.dtvalidity) = datepart(year,getdate()))
) _sub
