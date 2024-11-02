select rev.cdrevision, rev.iddocument, rev.nmtitle, gnrev.idrevision
, case doc.fgstatus when 1 then 'Emissão' when 2 then 'Homologado' when 3 then 'Em revisão' when 4 then 'Cancelado' when 5 then 'Em indexação' end statusdoc
, format(gnrev.dtrevision,'dd/MM/yyyy') as dtrevisao, datepart(yyyy,gnrev.dtrevision) as dtrevisao_ano, datepart(MM,gnrev.dtrevision) as dtrevisao_mes
, format(prot.DTPRINTCOPYPROT,'dd/MM/yyyy') as dtdistribuida, datepart(yyyy,prot.DTPRINTCOPYPROT) as dtdistribuida_ano, datepart(MM,prot.DTPRINTCOPYPROT) as dtdistribuida_mes
, format(prot.DTUSERRECCONF,'dd/MM/yyyy') as dtconfirmada, datepart(yyyy,prot.DTUSERRECCONF) as dtconfirmada_ano, datepart(MM,prot.DTUSERRECCONF) as dtconfirmada_mes
, copyst.NMCOPYSTATION
, format((select max(prc.DTPRINTCOPYCANCEL) from DCPRINTCOPYCANCEL prc where prc.cddocument = rev.cddocument and prc.cdrevision = rev.cdrevision),'dd/MM/yyyy') as dtrecolhida
, datepart(yyyy,(select max(prc.DTPRINTCOPYCANCEL) from DCPRINTCOPYCANCEL prc where prc.cddocument = rev.cddocument and prc.cdrevision = rev.cdrevision)) as dtrecolhida_ano
, datepart(MM,(select max(prc.DTPRINTCOPYCANCEL) from DCPRINTCOPYCANCEL prc where prc.cddocument = rev.cddocument and prc.cdrevision = rev.cdrevision)) as dtrecolhida_mes
, 1 as quantidade
from dcdocrevision rev
inner join dcdocument doc on doc.cddocument = rev.cddocument
inner join gnrevision gnrev on gnrev.cdrevision = rev.cdrevision
inner join DCPRINTCOPYprotdoc protdoc on protdoc.cdrevision = rev.cdrevision
inner join DCPRINTCOPYprot prot on prot.cdprintcopyprot =  protdoc.cdprintcopyprot
inner join dccopystation copyst on copyst.CDCOPYSTATION = prot.CDCOPYSTATION
where rev.cdcategory in (523)
