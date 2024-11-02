select rev.iddocument
, req.IDREQUEST, rqtype.IDREQUESTTYPE +' - '+ rqtype.NMREQUESTTYPE as ReqType
, req.DTREQUEST as dtReqAberta, apro.DTAPPROV as dtReqAprovada, usr.nmuser as ReqAprovador
, req.DTUPDATE as ReqAtualizadoEm, req.NMUSERUPD as ReqAtualizadoPor
, case when req.DTREQUEST is null then req.DTREQUEST else gnrev.DTREVCREATE end as ReqAtendida
, rev.nmtitle, gnrev.idrevision, rev.cdrevision
, case when substring(cat.idcategory, 1, 1) in ('1','2','3','4','5','6','7','8','9','0') then substring(cat.idcategory, 5, 50) else cat.idcategory end idcategory
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, case when (rev.fgcurrent = 1 and doc.fgstatus <> 1) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão'
when rev.fgcurrent = 2 then case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev
, gnrev.dtrevprogstart, gnrev.dtrevprogfinish, rev.dtinsert as dtrevrealstart, gnrev.dtrevrealfinish as dtrevrealfinishH
, (select top 1 max(stag1.dtapproval)
from GNREVISIONSTAGMEM stag1
where stag1.CDREVISION = gnrev.CDREVISION AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE = 3
) as dtrevrealfinishA
, datediff(DD, gnrev.DTREVPROGFINISH, gnrev.DTREVREALFINISH) as FimDif
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, stag.qtdeadline, stag.NRCYCLE as ciclo, stag.NRSEQUENCE, stag.CDMEMBERINDEX
, stag.dtdeadline as dtdeadline
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when stag.cdposition is null then case when stag.cdteam is null then 'NA'
else (select nmteam from adteam where cdteam = stag.cdteam) end else (select pos.nmposition from adposition pos where pos.cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, case when stag.CDUSER is null then 'NA' else (select dep.nmdepartment from addepartment dep inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and FGDEFAULTDEPTPOS = 1 where rel.cduser = stag.cduser) end depExecutor
, stag.dtapproval as dtexecut
, case stag.fgapproval when 1 then 'Aprovado' when 2 then 'Reprovado' when 3 then 'Temporal' end acao
, datediff(DD, stag.dtdeadline, stag.dtapproval) as leadtime
, his.dtaccess as dtCancel
, his.NMREVISION as revCancel, his.nmuser as nmuserCancel, cast(his.dsjustify as varchar(4000)) as jutificCancel
, (select nmattribute from adattribvalue where cdattribute = 2 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 2 and cdrevision = rev.cdrevision)) as areaUQ
, (select nmattribute from adattribvalue where cdattribute = 3 and cdvalue = (select cdvalue from dcdocumentattrib where cdattribute = 3 and cdrevision = rev.cdrevision)) as areaEmitenteUQ
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from DCDOCMULTIATTRIB dcatt
inner join adattribvalue attvl on attvl.cdattribute = dcatt.cdattribute and attvl.cdvalue = dcatt.cdvalue
where dcatt.cdrevision = rev.cdrevision and dcatt.cdattribute = 278
FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as areasRespBSB
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from DCDOCMULTIATTRIB dcatt
inner join adattribvalue attvl on attvl.cdattribute = dcatt.cdattribute and attvl.cdvalue = dcatt.cdvalue
where dcatt.cdrevision = rev.cdrevision and dcatt.cdattribute = 8
FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as areasAbrangBSB
, cast(coalesce((select substring((select ' | '+ attvl.nmattribute as [text()] from DCDOCMULTIATTRIB dcatt
inner join adattribvalue attvl on attvl.cdattribute = dcatt.cdattribute and attvl.cdvalue = dcatt.cdvalue
where dcatt.cdrevision = rev.cdrevision and dcatt.cdattribute = 7
FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as LinhasProdBSB
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevisionassoc = revc.cdrevision
where assoc.cdrevision = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as compostode --listadocfilho--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevision = revc.cdrevision
where assoc.cdrevisionassoc = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as usadoem --listadocpai--
, coalesce((select substring((select ' | '+ cast(crit.nrcritic as varchar(255)) +') '+ cast(crit.dscritic as varchar(4000)) as [text()] from GNREVISIONCRITIC crit
where crit.cdrevision = rev.cdrevision and crit.nrcycle = stag.nrcycle FOR XML PATH('')), 4, 4000)), 'NA') as criticas --listacríticas--
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL
left join DCAUDITSYSTEM his on his.NMDOCTO = rev.iddocument and his.fgtype in (11) and doc.fgstatus = 4
left join GNREVISIONREQASSOC assrev on gnrev.cdrevision = assrev.cdrevision
left join GNREQUEST req on assrev.cdrequest = req.cdrequest
left join GNAPPROVRESP apro on apro.CDPROD = req.CDPROD and apro.CDAPPROV = req.CDAPPROV and apro.DTAPPROV is not null
left join gnrequesttype rqtype on rqtype.CDREQUESTTYPE = req.CDREQUESTTYPE
left join aduser usr on usr.cduser = apro.CDUSERAPPROV
where rev.cdcategory in (209, 210, 211)
