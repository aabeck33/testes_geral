select cat.idcategory, rev.iddocument, gnrev.idrevision, rev.nmtitle
, case when doc.fgstatus <> 2 then case stag.FGSTAGE when 1 then 'Elaboração' when 2 then 'Consenso' when 3 then 'Aprovação' when 4 then 'Homologação' when 5 then 'Liberação' when 6 then ' Encerramento' end 
else case when gnrev.dtrevision <= '2024/10/20' then 'Não iniciado' else 'Homologado' end
end fase
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' when 7 then 'Contrato encerrado' end statusdoc
, case when doc.fgstatus <> 2 then case when stag.CDUSER is null then case when stag.cddepartment is null then case when cdposition is null then case when cdteam is null then 'NA' 
  else (select nmteam from adteam where cdteam = stag.cdteam) end else (select nmposition from adposition where cdposition = stag.cdposition) end else (select nmdepartment from addepartment where cddepartment = stag.cddepartment) end else (select nmuser from aduser where cduser = stag.cduser) end else 'N/A' end Executor
, case when doc.fgstatus <> 2 then stag.dtdeadline else getdate() end dtdeadline, gnrev.dtrevision
, 1 as qtd
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join dccategory cat on cat.cdcategory = rev.cdcategory
left JOIN GNREVISIONSTAGMEM stag ON gnrev.CDREVISION = stag.CDREVISION AND stag.dtdeadline IS NOT NULL and stag.nrcycle = (select max(stagx.nrcycle) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION)
where rev.iddocument in ('POP-SG-C-220','POP-SG-C-223','POP-SG-G-001','POP-SG-G-002','POP-SG-G-003','POP-SG-G-004','POP-SG-G-005','POP-SG-G-006','POP-SG-G-008',
						 'POP-SG-G-010','POP-SG-G-012','POP-SG-G-173','POP-SG-G-176','POP-SG-G-190','POP-SG-G-194','POP-SG-M-032','POP-SG-N-013','POP-SG-N-014','POP-SG-N-015',
						 'POP-SG-N-016','POP-SG-N-017','POP-IN-B-002','POP-IN-B-003','POP-IN-B-005','POP-IN-B-006','POP-IN-B-007','POP-IN-H-043','POP-IN-O-009','POP-IN-O-016',
						 'POP-IN-O-039','POP-IN-O-047','POP-IN-O-074','POP-IN-O-159','POP-IN-O-174','POP-IN-O-189','POP-IN-O-198','POP-IN-O-200','POP-IN-O-250','POP-IN-O-261',
						 'POP-IN-O-270','POP-IN-O-293','POP-IN-O-295','POP-IN-O-302','POP-IN-O-310','POP-IN-O-318','POP-IN-O-344','POP-IN-O-408','POP-IN-O-411','POP-IN-O-458',
						 'POP-IN-E-145','POP-IN-F-368','POP-IN-U-010','POP-TDS-F-097','POP-TDS-C-003','POP-TDS-C-005','POP-TDS-N-001','POP-TDS-N-002','POP-TDS-N-003',
						 'POP-TDS-N-004','POP-TDS-N-005','POP-TDS-E-067','POP-TDS-G-148','POP-TDS-M-027','POP-TDS-M-031','POP-TDS-G-123','POP-TDS-G-170','POP-TDS-G-001',
						 'POP-TDS-G-002','POP-TDS-G-109','POP-TDS-G-168','POP-TDS-G-140','POP-TDS-G-121','POP-TDS-G-012','BR-A.0001','BR-A.0039','BR-A.0077','BR-A.0200',
						 'BR-A.0219','BR-A.0221','BR-A.0224','BR-A.0238','BR-A.0248','BR-A.0249','BR-A.0252','BR-A.0257','BR-A.0265','BR-B.0426','BR-D.0129','BR-F.0010','BR-F.0105',
						 'BR-M.0001','BR-M.0002','BR-M.0003','BR-U.0007','POP-CORP-A-0001','POP-CORP-A-0010','POP-CORP-A-0012','POP-CORP-B-0001','POP-CORP-M-0002',
						 'POP-CORP-M-0004','POP-CORP-M-0005','POP-CORP-M-0006','POP-CORP-M-0007','POP-HUM-LB-A-001','POP-HUM-LB-A-048','POP-HUM-LB-A-056','PA-A.0001',
						 'PA-A.0039','PA-A.0077','PA-A.0081','PA-A.0246','PA-A.0259','PA-A.0262','PA-A.0272','PA-B.0334','PA-B.0417','PA-B.0437','PA-B.0440','PA-B.0493','EX-A.0001','EX-A.0013','EX-A.0036','EX-A.0045','EX-Z.0001',
						 'PA-F.0153','PA-M.0002','PA-M.0003','PA-M.0004','PA-Q.0015','PA-U.0001','EG-A.0001','EG-A.0039','EG-A.0077','EG-A.0081','EG-A.0194','EG-A.0218','EG-A.0223','EG-A.0229','EG-B.0416',
						 'EG-F.0110','EG-L.0144','EG-M.0001','EG-M.0002','EG-M.0003','EG-N.0105','EG-Q.0007','VET-EG-A.0001','VET-EG-A.0188','VET-EG-A.0214','VET-EG-A.0219',
						 'VET-EG-A.0221','VET-EG-N.0078','VET-EG-N.0082','VET-EG-N.0084')
and ((stag.dtapproval is null and rev.fgcurrent = 1 and doc.fgstatus = 1) or
(rev.cdrevision = (select max(cdrevision) from dcdocrevision where CDDOCUMENT = rev.cddocument)) and 
(stag.dtapproval = (select max(stagx.dtapproval) from GNREVISIONSTAGMEM stagx where stagx.CDREVISION = gnrev.CDREVISION) or stag.dtapproval is null))
