SELECT dr.iddocument +'/'+ gr.idrevision as filho, wfproc.idprocess as pai, wfproc.nmprocessmodel, wfproc.nmprocess, wfproc.nmuserstart, wfproc.fgconcludedstatus, wfproc.dtstart
, case wfproc.fgstatus
    WHEN 1 THEN 'Em andamento'
    WHEN 2 THEN 'Suspenso'
    WHEN 3 THEN 'Cancelado'
    WHEN 4 THEN 'Encerrado'
    WHEN 5 THEN 'Bloqueado para edição'
END AS status
, gr.dtrevision
, (select adt.idteam from adteam adt where adt.cdteam = stag.cdteam) as idteam
, stag.dtdeadline, stag.fgapproval, stag.dtapproval, stag.nmuserupd, stag.qtdeadline
, case stag.fgstage when 1 then 'Elaboração/Draft' when 2 then 'Aprovação/Approval' end fase
, 1 as qtd
FROM dcdocrevision dr
INNER JOIN dcdocument dc ON dc.cddocument = dr.cddocument
INNER JOIN gnrevision gr ON gr.cdrevision = dr.cdrevision
INNER JOIN wfprocdocument wfdoc ON dr.cddocument = wfdoc.cddocument AND (dr.cdrevision = wfdoc.cddocumentrevis OR (wfdoc.cddocumentrevis IS NULL AND dr.fgcurrent = 1))
INNER JOIN wfstruct wfs ON wfdoc.idstruct = wfs.idobject
INNER JOIN wfprocess wfproc ON wfs.idprocess = wfproc.idobject
left JOIN GNREVISIONSTAGMEM stag ON gr.CDREVISION = stag.CDREVISION
WHERE  wfproc.cdprocessmodel in (8724)
