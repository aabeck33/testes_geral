select cat.idcategory +' - '+ cat.nmcategory as Categoria, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case rev.fgcurrent when 1 then 'Vigente' when 2 then 'Obsoleta' end statusrev
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Revisão' when 4 then '/do' when 5 then 'Indexação' end statusdoc
, format(gnrev.dtrevision,'dd/MM/yyyy') as dtrev, datepart(yyyy,gnrev.dtrevision) as dtrev_ano, datepart(MM,gnrev.dtrevision) as dtrev_mes
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevisionassoc = revc.cdrevision
where assoc.cdrevision = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as compostode --listadocfilho--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevision = revc.cdrevision
where assoc.cdrevisionassoc = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as usadoem --listadocpai--
, 1 as quantidade
from dcdocrevision rev
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dcdocument doc on rev.cddocument = doc.cddocument
where doc.fgstatus < 4 and rev.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)
and cat.cdcategory in (126,127,113,129,116,117,120,121,122,138,128,114,118,123,124,131,134,139,133)
and rev.fgcurrent = 1
