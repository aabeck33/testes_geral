select cat.idcategory +' - '+ cat.nmcategory as Categoria, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case rev.fgcurrent when 1 then 'Vigente' when 2 then 'Obsoleta' end statusrev
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Revisão' when 4 then 'Cancelado' when 5 then 'Indexação' end statusdoc
, case when (select nmvalue from dcdocumentattrib where cdattribute = 204 and cdrevision = rev.cdrevision) is null then 'NA' else 
(select nmvalue from dcdocumentattrib where cdattribute = 204 and cdrevision = rev.cdrevision) end Indexacao_cliente
, format(gnrev.dtrevision,'dd/MM/yyyy') as dtrev, datepart(yyyy,gnrev.dtrevision) as dtrev_ano, datepart(MM,gnrev.dtrevision) as dtrev_mes
, format(gnrev.dtvalidity,'dd/MM/yyyy') as dtvalidade, datepart(yyyy,gnrev.dtvalidity) as dtvalidade_ano, datepart(MM,gnrev.dtvalidity) as dtvalidade_mes
, 1 as quantidade
from dcdocrevision rev
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dcdocument doc on rev.cddocument = doc.cddocument
where doc.fgstatus < 4 and rev.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)
and cat.cdcategory in (126,127,113,129,116,117,120,121,122,138)
and rev.fgcurrent = 1
