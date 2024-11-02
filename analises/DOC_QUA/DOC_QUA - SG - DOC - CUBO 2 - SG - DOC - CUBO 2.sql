select rev.iddocument, rev.nmtitle, gnrev.idrevision, rev.cdrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, case when (rev.fgcurrent = 1 and doc.fgstatus <> 1) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' 
       when rev.fgcurrent = 2 then case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev
, format(gnrev.dtrevision,'dd/MM/yyyy') as dtrevisao, datepart(yyyy,gnrev.dtrevision) as dtrevisao_ano, datepart(MM,gnrev.dtrevision) as dtrevisao_mes
, format(gnrev.dtvalidity,'dd/MM/yyyy') as dtvalidade, datepart(yyyy,gnrev.dtvalidity) as dtvalidade_ano, datepart(MM,gnrev.dtvalidity) as dtvalidade_mes
, format(his.dtaccess,'dd/MM/yyyy') as dtcancel, datepart(yyyy,his.dtaccess) as dtcancel_ano, datepart(MM,his.dtaccess) as dtcancel_mes
, his.NMREVISION as revcancel, his.nmuser, cast(his.dsjustify as varchar(4000)) as jutificativa
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevisionassoc = revc.cdrevision
where assoc.cdrevision = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as compostode --listadocfilho--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevision = revc.cdrevision
where assoc.cdrevisionassoc = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as usadoem --listadocpai--
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left join DCAUDITSYSTEM his on his.NMDOCTO = rev.iddocument and his.fgtype in (11) and doc.fgstatus = 4
where rev.cdcategory in (447,448,449,450)
