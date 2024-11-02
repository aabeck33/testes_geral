select rev.iddocument, rev.nmtitle
, format(stag.dtapproval,'dd/MM/yyyy') as dtexecut --, datepart(yyyy,stag.dtapproval) as dtexecut_ano, datepart(MM,stag.dtapproval) as dtexecut_mes
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, 1 as quantidade
, gnrev.idrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, case when (rev.fgcurrent = 1 and doc.fgstatus <> 1) then 'Vigente' when (rev.fgcurrent = 1 and doc.fgstatus = 1) then 'Emissão' when rev.fgcurrent = 2 then 'Obsoleto' end statusrev
, stag.NRCYCLE as ciclo, stag.NRSEQUENCE, stag.CDMEMBERINDEX
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
left join DCAUDITSYSTEM his on his.NMDOCTO = rev.iddocument and his.fgtype in (11) and doc.fgstatus = 4
where rev.cdcategory in (161)
