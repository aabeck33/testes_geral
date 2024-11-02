Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, case dc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, wf.dtstart as dtabertura, wf.dtfinish as dtfechamento
, gr.dtrevision as dtrevisao, gr.dtvalidity as dtvalidade
, ct.idcategory, dr.iddocument, dr.nmtitle, gr.idrevision
--, dr.cddocument, dr.cdrevision, wfs.nmstruct, wfdoc.idprocess, wfdoc.cdprocdocument, wfs.idobject
, case when CDPHYSFILEFINLDEST is not null then 
    'Local final'
  else
    case when CDPHYSFILEINTERMED is not null then
      'Local intermediário'
    else
      case when CDPHYSFILECURRENT is not null then
        'Local corrente'
      else
        'Não arquivado'
      end
    end
  end as tplocal
, case when CDPHYSFILEFINLDEST is not null then 
    cast(locaf.dslocation as varchar(255)) +' - '+ locaf.nmphyslocation +' - '+ repof.nmbox
  else
    case when CDPHYSFILEINTERMED is not null then
      cast(locai.dslocation as varchar(255)) +' - '+ locai.nmphyslocation +' - '+ repoi.nmbox
    else
      cast(locac.dslocation as varchar(255)) +' - '+ locac.nmphyslocation +' - '+ repoc.nmbox
    end
  end as localizacao
--, cast(locac.dslocation as varchar(255)) +' - '+ locac.nmphyslocation +' - '+ repoc.nmbox as localizacao
--, cast(locai.dslocation as varchar(255)) +' - '+ locai.nmphyslocation +' - '+ repoi.nmbox as localizacao
--, cast(locaf.dslocation as varchar(255)) +' - '+ locaf.nmphyslocation +' - '+ repof.nmbox as localizacao
--, CDPHYSFILECURRENT, CDPHYSFILEINTERMED, CDPHYSFILEFINLDEST
, 1 as quantidade
FROM dcdocrevision dr
INNER JOIN dcdocument dc ON dc.cddocument = dr.cddocument
INNER JOIN dccategory ct ON dr.cdcategory = ct.cdcategory
INNER JOIN gnrevision gr ON gr.cdrevision = dr.cdrevision
INNER JOIN wfprocdocument wfdoc ON dr.cddocument = wfdoc.cddocument AND (dr.cdrevision = wfdoc.cddocumentrevis 
           OR (wfdoc.cddocumentrevis IS NULL AND dr.fgcurrent = 1))
INNER JOIN wfstruct wfs ON wfdoc.idstruct = wfs.idobject
INNER JOIN wfprocess wf ON wfs.idprocess = wf.idobject
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DCDOCUMENTARCHIVAL fisico on fisico.cddocument = dc.cddocument
left join DCPHYSICALFILE repoc on fisico.CDPHYSFILECURRENT = repoc.CDPHYSICALFILE
left join DCPHYSICALFILE repoi on fisico.CDPHYSFILEINTERMED = repoi.CDPHYSICALFILE
left join DCPHYSICALFILE repof on fisico.CDPHYSFILEFINLDEST = repof.CDPHYSICALFILE
left join DCPHYSLOCATION locac on locac.CDPHYSLOCATION = repoc. CDPHYSLOCATION
left join DCPHYSLOCATION locai on locai.CDPHYSLOCATION = repoi. CDPHYSLOCATION
left join DCPHYSLOCATION locaf on locaf.CDPHYSLOCATION = repof. CDPHYSLOCATION
WHERE wf.cdprocessmodel=2808 or wf.cdprocessmodel=2909
