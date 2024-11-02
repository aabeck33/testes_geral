select rev.cdrevision, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, gnrev.dtrevision as dtrevisao
, prot.DTPRINTCOPYPROT as dtdistribuida
, prot.DTUSERRECCONF as dtconfirmada
, copyst.NMCOPYSTATION
, (select max(prc.DTPRINTCOPYCANCEL) from DCPRINTCOPYCANCEL prc where prc.cddocument = rev.cddocument and prc.cdrevision = rev.cdrevision) as dtrecolhida
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join DCPRINTCOPYprotdoc protdoc on protdoc.cdrevision = rev.cdrevision
inner join DCPRINTCOPYprot prot on prot.cdprintcopyprot =  protdoc.cdprintcopyprot
inner join dccopystation copyst on copyst.CDCOPYSTATION = prot.CDCOPYSTATION
where rev.cdcategory in (219,222,257,223)
