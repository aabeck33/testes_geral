select *
from (
select wf.idprocess, wf.nmprocess, form.itsm066 as gruposolucionador
, CASE wf.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, case when (docs.iddocument is null and wf.fgstatus = 1) then 'Não iniciado'
	   when ((docs.iddocument like 'APL-DE-%' or docs.iddocument like 'SAP-DE-%') and wf.fgstatus = 1) then 'Em andamento'
		when (exists (select 1
                    FROM WFSTRUCT wfs, WFHISTORY HIS
                    WHERE wfs.idstruct = 'Atividade20111012624715' and wfs.idprocess = wf.idobject
                    and HIS.IDSTRUCT = wfs.IDOBJECT and his.idprocess = wf.idobject and HIS.FGTYPE = 9 and his.nmaction = 'Submeter / Submit') and wf.fgstatus = 1) then 'Entregue'
       when wf.fgstatus = 2 then 'Suspenso'
       when wf.fgstatus = 3 then 'Cancelado'
       when wf.fgstatus = 4 then 'Finalizado'
end Status2
, form.itsm041, form.itsm048, form.itsm040
, docs.VLVALUE as chamado
, (select case when (charindex('#RESP#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#RESP#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#RESP#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#RESP#%'))
) as resp
, (select case when (charindex('#PEND#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#PEND#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#PEND#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#PEND#%'))
) as pend
, (select case when (charindex('#USAC#', his.dscomment) = 0 or his.dscomment is null) then null else substring(his.dscomment, charindex('#USAC#', his.dscomment) +6, charindex(char(10),(substring(his.dscomment, charindex('#USAC#', his.dscomment) +6, 250)))) end
from wfhistory his
where his.idprocess = wf.idobject and his.dthistory + his.tmhistory = (
select max(dthistory + tmhistory) from wfhistory where idprocess = wf.idobject and fgtype = 11 and (dscomment like '%#USAC#%'))
) as usracc
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-DC-%' or dr.iddocument like 'SAP-DC-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as DC
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-DP-%' or dr.iddocument like 'SAP-DP-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as DP
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-DE-%' or dr.iddocument like 'SAP-DE-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as DE
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-EF-%' or dr.iddocument like 'SAP-EF-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as EF
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-ET-%' or dr.iddocument like 'SAP-ET-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as ET
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-QO-%' or dr.iddocument like 'SAP-QO-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as QO
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-QR-%' or dr.iddocument like 'SAP-QR-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as QR
, (select top 1 dr.iddocument +' / '+ case doc.fgstatus when 1 then 'Em fluxo' when 2 then 'Homologado' when 3 then 'Em fluxo' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end
+ case doc.fgstatus when 1 then +' - '+ stuff((select cast(';' as nvarchar(max)) + case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end +' - '+ format(stag.dtdeadline, 'dd/MM/yyyy', 'pt-BR') as [text()]
from GNREVISIONSTAGMEM stag where dr.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (
select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = dr.CDREVISION) and stag.FGAPPROVAL is null
FOR XML PATH('')), 1, 1, '') else '' end
from dcdocrevision dr
inner join dcdocument doc on doc.cddocument = dr.cddocument
inner join dcdocumentattrib atr on atr.cdrevision = dr.cdrevision and atr.cdattribute = 235
where (dr.iddocument like 'APL-RP-%' or dr.iddocument like 'SAP-RP-%') and atr.vlvalue = docs.vlvalue
order by dr.cdrevision desc) as RP
, case when (<!%IDLOGIN%> in (select usr.idlogin from aduser usr inner join aduserdeptpos rel on rel.cduser = usr.cduser and fgdefaultdeptpos = 1 inner join addepartment dep on dep.cddepartment = rel.cddepartment and (dep.nmdepartment like 'Tecnologia da Informa%' or dep.nmdepartment like 'Information Tech%'))) then 1 else 2 end usrti
, form.itsm035 as GS
, wfs.idstruct, wfs.nmstruct, wf.dtfinish
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left join WFSTRUCT wfs on wfs.idprocess = wf.idobject and wfs.fgstatus = 2
left join (
            select wfs.idprocess, rev.iddocument, att.VLVALUE, rev.cddocument, rev.cdrevision
            from wfstruct wfs
            inner join wfprocdocument wfdoc on wfdoc.idstruct = wfs.idobject
            inner join dcdocrevision rev on rev.cddocument = wfdoc.cddocument and (rev.cdrevision = wfdoc.cddocumentrevis or (wfdoc.cddocumentrevis is null and rev.cdrevision = (select max(cdrevision) from dcdocrevision where cddocument = rev.cddocument)))
            inner join dcdocumentattrib att on att.cdrevision = rev.cdrevision and att.cdattribute = 235 and att.cdrevision = rev.cdrevision
            where (rev.iddocument like 'APL-__-%' or rev.iddocument like 'SAP-__-%')
) docs on docs.idprocess = wf.idobject
where wf.cdprocessmodel = 5679 and form.itsm035 is not null and  (wf.dtfinish is null or (wf.dtfinish BETWEEN DATEADD(DD, -90, getdate()) AND getdate()))
) sub
where status2 is not null
