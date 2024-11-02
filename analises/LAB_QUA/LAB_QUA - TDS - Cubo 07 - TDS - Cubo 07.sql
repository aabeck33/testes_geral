select cat.idcategory +' - '+ cat.nmcategory as Categoria, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Revisão' when 4 then 'Cancelado' when 5 then 'Indexação' end statusdoc
, moti.nmreason as motivorev
, case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end fase
, stag.NRCYCLE as ciclo, stag.qtdeadline
, format(stag.dtdeadline,'dd/MM/yyyy') as dtdeadline, datepart(yyyy,stag.dtdeadline) as dtdeadline_ano, datepart(MM,stag.dtdeadline) as dtdeadline_mes
, case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end Executor
, format(stag.dtapproval,'dd/MM/yyyy') as dtexecut, datepart(yyyy,stag.dtapproval) as dtexecut_ano, datepart(MM,stag.dtapproval) as dtexecut_mes
, case stag.fgapproval when 1 then 'Aprovado' when 2 then 'Reprovado' when 3 then 'Temporal' end acao
, case when (select nmvalue from dcdocumentattrib where cdattribute = 204 and cdrevision = rev.cdrevision) is null then 'NA' else 
(select nmvalue from dcdocumentattrib where cdattribute = 204 and cdrevision = rev.cdrevision) end Indexacao_cliente
, 1 as quantidade
from dcdocrevision rev
inner join dccategory cat on cat.cdcategory = rev.cdcategory
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dcdocument doc on rev.cddocument = doc.cddocument
INNER JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL
left join GNREASON moti on moti.cdreason = gnrev.CDREASON
where doc.fgstatus in (1,3) and rev.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)
and stag.dtdeadline is not null and cat.cdcategory in (126,127,113,129,116,117,120,121,122,138,128,114,118,123,124,131,134,139,133)
