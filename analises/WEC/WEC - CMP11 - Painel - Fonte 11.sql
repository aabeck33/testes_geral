Select wf.idprocess, gnrev.NMREVISIONSTATUS as status, wf.nmprocess, wf.dtstart
, case when wf.cdprocessmodel <> 2951 then combo1.con001 else 'Distrato' end as tipocontr
, case when coalesce(datediff(dd,
form.con078
, (SELECT HIS.DTHISTORY
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade16819124838176','Atividade1684133947305','Atividade16819125923303')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (6) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select min(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade16819124838176','Atividade1684133947305','Atividade16819125923303')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (6) and his1.idprocess = wf.idobject)
)), -1) = -1 then 'N/A'
when datediff(dd,
form.con078
, (SELECT HIS.DTHISTORY
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct in ('Atividade16819124838176','Atividade1684133947305','Atividade16819125923303')
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  HIS.FGTYPE IN (6) and his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select min(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct in ('Atividade16819124838176','Atividade1684133947305','Atividade16819125923303')
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  HIS1.FGTYPE IN (6) and his1.idprocess = wf.idobject)
)) < 120 then 'Em atraso'
else 'Em dia' end as prazo
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DYNcon001espec combo1 on combo1.oid = form.OIDABCzgOABC2Ih
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.fgtype = 6
inner JOIN WFSTRUCT struc ON HIS.IDSTRUCT = struc.IDOBJECT and struc.idprocess = wf.idobject and struc.fgstatus = 2
and HIS.DTHISTORY+HIS.TMHISTORY = (select max(HIS1.DTHISTORY+HIS1.TMHISTORY) FROM WFHISTORY HIS1 where his1.fgtype = 6 and his1.idprocess = wf.idobject and his1.idstruct = struc.idobject)
where (wf.cdprocessmodel = 2808)
and wf.fgstatus = 1
