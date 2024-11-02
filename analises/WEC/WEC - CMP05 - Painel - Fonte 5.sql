select qtdretornos, sum(quantidade) as quantidade
from (
Select wf.idprocess
, sum(1) as quantidade
, sum(1) as qtdretornos
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9 and his.nmaction = 'Retornar para solicitante'
inner join wfstruct stru on stru.idobject = his.idstruct and stru.idstruct in ('Atividade16819124838176', 'Atividade1684133947305','Atividade16819125923303')
where wf.cdprocessmodel = 2808 or wf.cdprocessmodel = 2909 or wf.cdprocessmodel = 2951
group by wf.idprocess
) _sub
group by qtdretornos
