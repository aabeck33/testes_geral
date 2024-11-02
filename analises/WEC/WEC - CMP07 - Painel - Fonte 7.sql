Select wf.idprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, stru.IDSTRUCT, stru.NMSTRUCT, coalesce(his.nmrole, 'Usuário') as tpexecut, his.nmuser, his.nmaction
, his.dthistory as dthistory, his.tmhistory
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9
inner join wfstruct stru on stru.idobject = his.idstruct and stru.idstruct in ('Decisão1696121412176', 'Decisão16119164313782')
where wf.cdprocessmodel = 2808 or wf.cdprocessmodel = 2909 or wf.cdprocessmodel = 2951
