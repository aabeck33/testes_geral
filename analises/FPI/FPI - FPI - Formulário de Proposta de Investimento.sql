select wf.idprocess as identificador, wf.nmprocess as titulo, gnrev.NMREVISIONSTATUS as status
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, wf.dtstart + wf.tmstart as dtinicio, wf.dtfinish + wf.tmfinish as dtfim

, Categoria.cat001 as Categoria_Projeto, form.proj003 as Descricao_ativo, form.proj001 as Centro_Custo, form.proj039 as Observacoes, form.proj042 as Comentarios_Contabilidade
, Filial.fil001 as Filial, struc.nmstruct as nmatvatual
, grid.fnc001 as Fase, grid.fnc002 as Descricao_fase, grid.fnc021 as Centro_custo_grid, grid.fnc004 as Fim_planejado, grid.fnc007a as QTD_Itens, simnao.simnao as Sera_instalado_MEQP, grid.fnc016 as Plaqueta, grid.fnc017 as Observacao_grid
, 1 as QTD
from DYNprojetos form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)

left join DYNauxfincatsol Categoria on form.OIDABCMD9HAABPSFJH = Categoria.oid
left join DYNauxfinfil Filial on form.OIDABCTUYZM9UX0ASN = Filial.oid

left join DYNgridfinanc grid on grid.OIDABC8PEVIZPSDDVQ = form.oid
left join DYNsimnao simnao on grid.OIDABCKUUEM2536YIK = simnao.oid
inner JOIN WFSTRUCT struc ON struc.idprocess = wf.idobject and struc.fgstatus = 2
inner join wfactivity wfa on struc.idobject = wfa.IDOBJECT

where wf.cdprocessmodel = 5210
