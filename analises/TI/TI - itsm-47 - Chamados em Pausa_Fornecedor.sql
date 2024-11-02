select wf.idprocess, wf.nmprocess, form.itsm035
, case wf.cdstatus
    when 114 then 'Forcenedor'
    when 128 then 'Pausa'
end tipo
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
, his.dthistory+his.tmhistory as desde, his.nmuser
, datediff(dd, his.dthistory+his.tmhistory, getdate()) tempo_dias
, cast(his.DSCOMMENT as varchar) as dscomment
, 1 as quant
from DYNitsm form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.FGTYPE = 9 and (his.nmaction = 'Aguardar / On hold' or his.nmaction = 'Enviar para fornecedor / Send to vendor')
and his.dthistory+his.tmhistory = (select max(his1.dthistory+his1.tmhistory) from WFHISTORY HIS1 where his1.idprocess = wf.idobject and his1.FGTYPE = 9 and (his1.nmaction = 'Aguardar / On hold' or his1.nmaction = 'Enviar para fornecedor / Send to vendor'))
where wf.cdprocessmodel=5251 and wf.cdstatus in (114, 128)
and wf.fgstatus = 1
