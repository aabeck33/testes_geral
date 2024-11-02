select cat.idcategory, rev.iddocument, rev.nmtitle, gnrev.idrevision, rev.cdrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, case when (rev.fgcurrent = 1 and doc.fgstatus <> 1) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' 
       when rev.fgcurrent = 2 then case when doc.fgstatus in (1, 3, 5) and rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument) then 'Em fluxo' else 'Obsoleto' end end statusrev
,rev.fgcurrent, gnrev.dtrevision as dtrevisao , gnrev.dtvalidity as dtvalidade
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, stag.qtdeadline, stag.NRCYCLE as ciclo, stag.NRSEQUENCE, stag.CDMEMBERINDEX
, stag.dtdeadline as dtdeadline
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, stag.dtapproval as dtexecut
, case stag.fgapproval when 1 then 'Aprovado' when 2 then 'Reprovado' when 3 then 'Temporal' end acao
, case when cast(cast(stag.NRCYCLE as varchar(255))+cast(stag.FGSTAGE as varchar(255))+cast(stag.NRSEQUENCE as varchar(255))+cast(stag.CDMEMBERINDEX as varchar(255)) as integer) =
       (select min(cast(cast(stag2.NRCYCLE as varchar(255))+cast(stag2.FGSTAGE as varchar(255))+cast(stag2.NRSEQUENCE as varchar(255))+cast(stag2.CDMEMBERINDEX as varchar(255)) as integer))
        from GNREVISIONSTAGMEM stag2
        where stag2.cdrevision = stag.cdrevision
       ) then datediff(dd,gnrev.DTREVCREATE,stag.DTAPPROVAL)
  else
       datediff(dd,(select stag3.dtapproval from GNREVISIONSTAGMEM stag3
                    where cast(cast(stag3.NRCYCLE as varchar(255))+cast(stag3.FGSTAGE as varchar(255))+cast(stag3.NRSEQUENCE as varchar(255))+cast(stag3.CDMEMBERINDEX as varchar(255)) as integer) = 
                           (select max(cast(cast(stag2.NRCYCLE as varchar(255))+cast(stag2.FGSTAGE as varchar(255))+cast(stag2.NRSEQUENCE as varchar(255))+cast(stag2.CDMEMBERINDEX as varchar(255)) as integer)) as code
        from GNREVISIONSTAGMEM stag2
        where stag2.cdrevision = stag.cdrevision and cast(cast(stag2.NRCYCLE as varchar(255))+cast(stag2.FGSTAGE as varchar(255))+cast(stag2.NRSEQUENCE as varchar(255))+cast(stag2.CDMEMBERINDEX as varchar(255)) as integer) <
              cast(cast(stag.NRCYCLE as varchar(255))+cast(stag.FGSTAGE as varchar(255))+cast(stag.NRSEQUENCE as varchar(255))+cast(stag.CDMEMBERINDEX as varchar(255)) as integer)
         and stag2.dtapproval is not null) and stag3.cdrevision = rev.cdrevision),stag.DTAPPROVAL)
  end leadtime
, his.dtaccess as dtcancel
, his.NMREVISION as revcancel, his.nmuser, cast(his.dsjustify as varchar(4000)) as jutificativa
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevisionassoc = revc.cdrevision
where assoc.cdrevision = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as compostode --listadocfilho--
, coalesce((select substring((select ' | '+ revc.iddocument +' - '+ revc.nmtitle as [text()] from GNREVISIONASSOC assoc inner join dcdocrevision revc on assoc.cdrevision = revc.cdrevision
where assoc.cdrevisionassoc = rev.cdrevision FOR XML PATH('')), 4, 4000)), 'NA') as usadoem --listadocpai--
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dccategory cat on cat.cdcategory = rev.cdcategory

left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
left join DCAUDITSYSTEM his on his.NMDOCTO = rev.iddocument and his.fgtype in (11) and doc.fgstatus = 4
where cat.idcategory like '%sg%'
