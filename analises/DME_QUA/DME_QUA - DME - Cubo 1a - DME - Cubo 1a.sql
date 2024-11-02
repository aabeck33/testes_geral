select rev.iddocument, rev.nmtitle, gnrev.idrevision, rev.cdrevision
, case when substring(cat.idcategory, 1, 1) in ('1','2','3','4','5','6','7','8','9','0') then substring(cat.idcategory, 5, 50) else cat.idcategory end idcategory
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, case rev.cdcategory
    when  39 then 'BSB'
    when  45 then 'BSB'
    when 110 then 'AN'
    when 111 then 'AN'
    when 112 then 'AN'
	when 113 then 'AN'
	when 114 then 'AN'
	when 145 then 'BSB'
	when 146 then 'BSB'
    when 225 then 'IN'
    when 226 then 'IN'
	when 227 then 'IN'
	when 243 then 'IN'
	when 265 then 'BSB'
	when 304 then 'UA'
	when 305 then 'UA'
	when 306 then 'UA'
	when 307 then 'UA'
	when 308 then 'UA'
	when 452 then 'SG'
	when 453 then 'SG'
	when 454 then 'SG'
	when 455 then 'SG'
	when 456 then 'SG'
	when 652 then 'CORP'
    else 'N/A'
end unidade
, datediff(dd, rev.dtinsert, (select max(coalesce(stagld.dtapproval, cast(0 as datetime)) + coalesce(stagld.tmapproval, cast(0 as datetime))) from GNREVISIONSTAGMEM stagld
where stagld.cdrevision = stag.cdrevision and stagld.nrcycle = stag.nrcycle and stagld.fgstage = 3)) +1 as leadtimeaprov
, case when (rev.fgcurrent = 1 and doc.fgstatus <> 1) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' 
       when rev.fgcurrent = 2 then case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev
, gnrev.dtrevprogstart, gnrev.dtrevprogfinish, rev.dtinsert as dtrevrealstart, gnrev.dtrevrealfinish as dtrevrealfinishH
, (select top 1 max(stag1.dtapproval)
from GNREVISIONSTAGMEM stag1
where stag1.CDREVISION = gnrev.CDREVISION AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE = 3
) as dtrevrealfinishA
, datediff(DD, gnrev.DTREVPROGFINISH, gnrev.DTREVREALFINISH) as FimDif
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, stag.qtdeadline
, stag.NRCYCLE as ciclo
, stag.NRSEQUENCE
, stag.CDMEMBERINDEX
, stag.dtdeadline as dtdeadline
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, case when stag.CDUSER is null then 'NA' else (select dep.nmdepartment from addepartment dep inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and FGDEFAULTDEPTPOS = 1 where rel.cduser = stag.cduser) end depExecutor
, stag.dtapproval as dtexecut
, case stag.fgapproval when 1 then 'Aprovado' when 2 then 'Reprovado' when 3 then 'Temporal' end acao
, datediff(DD, stag.dtdeadline, stag.dtapproval) as leadtime
, his.dtaccess as dtCancel
, his.NMREVISION as revCancel, his.nmuser as nmuserCancel, cast(his.dsjustify as varchar(4000)) as jutificCancel
, (select nmattribute from adattribvalue where cdattribute = 200 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 200 and cdrevision = rev.cdrevision)) as cod_sap_cyrel
, (select nmattribute from adattribvalue where cdattribute = 199 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 199 and cdrevision = rev.cdrevision)) as cod_sap_tira
, (select nmattribute from adattribvalue where cdattribute = 193 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 193 and cdrevision = rev.cdrevision)) as pharmacode
, (select nmattribute from adattribvalue where cdattribute = 192 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 192 and cdrevision = rev.cdrevision)) as destec
, (select nmattribute from adattribvalue where cdattribute = 146 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 146 and cdrevision = rev.cdrevision)) as tpfaca
, (select nmattribute from adattribvalue where cdattribute = 145 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 145 and cdrevision = rev.cdrevision)) as faca
, (select nmattribute from adattribvalue where cdattribute = 142 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 142 and cdrevision = rev.cdrevision)) as utilmatemb
, (select nmattribute from adattribvalue where cdattribute = 141 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 141 and cdrevision = rev.cdrevision)) as tpmatemb
, (select nmattribute from adattribvalue where cdattribute = 140 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 140 and cdrevision = rev.cdrevision)) as codanter
, (select nmattribute from adattribvalue where cdattribute = 138 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 138 and cdrevision = rev.cdrevision)) as codanovis
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from DCDOCMULTIATTRIB dcatt
                 inner join adattribvalue attvl on attvl.cdattribute = dcatt.cdattribute and attvl.cdvalue = dcatt.cdvalue
                 where dcatt.cdrevision = rev.cdrevision and dcatt.cdattribute = 143
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listapaís --listapaís--
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from DCDOCMULTIATTRIB dcatt
                 inner join adattribvalue attvl on attvl.cdattribute = dcatt.cdattribute and attvl.cdvalue = dcatt.cdvalue
                 where dcatt.cdrevision = rev.cdrevision and dcatt.cdattribute = 144
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listalinhaemb --listalinhaemb--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevisionassoc = revc.cdrevision
where assoc.cdrevision = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as compostode --listadocfilho--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevision = revc.cdrevision
where assoc.cdrevisionassoc = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as usadoem --listadocpai--
, coalesce((select substring((select ' | '+ cast(crit.nrcritic as varchar(255)) +') '+ cast(crit.dscritic as varchar(4000)) as [text()] from GNREVISIONCRITIC crit
            where crit.cdrevision = rev.cdrevision and crit.nrcycle = stag.nrcycle FOR XML PATH('')), 4, 4000)), 'NA') as criticas --listacríticas--
, GNREV.NRLASTCYCLE AS ULT_CICLO			
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left JOIN GNREVISIONSTAGMEM stag ON (gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle=(select max(stag1.nrcycle) from GNREVISIONSTAGMEM stag1 where (gnrev.CDREVISION = stag1.CDREVISION) ))
left join DCAUDITSYSTEM his on his.NMDOCTO = rev.iddocument and his.fgtype in (11) and doc.fgstatus = 4
where rev.cdcategory in (39, 45, 110, 111, 112, 225, 226, 113, 114, 145, 146, 227, 243, 265, 304, 305, 306, 307, 308, 195, 198, 452, 453, 454, 455, 456, 652)
and (datepart(year,gnrev.dtrevrealfinish) = <!%YEAR%> or gnrev.dtrevrealfinish is null)
