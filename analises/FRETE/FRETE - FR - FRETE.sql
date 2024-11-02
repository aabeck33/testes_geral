select wf.idprocess as identificador, wf.nmprocess as titulo, gnrev.NMREVISIONSTATUS as status
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, wf.dtstart + wf.tmstart as dtinicio, wf.dtfinish + wf.tmfinish as dtfim
, form.fr001 as solicitante, form.fr002 as depsolicit, form.fr005 as nmorigem
, form.fr006 +' ,Nº '+ form.fr061+',CEP '+form.fr058 as Endereco_Origem
, form.fr007 as cidadeorigem, uforig.a001 as uforig
, form.fr011 as dtcoletasug, form.fr012 as dtcoletaprog, form.fr013 as dtcoletareal
, form.fr014 as nmdest
, form.fr015 +' ,Nº '+ form.fr063+',CEP '+form.fr065 as Endereco_Destino
, form.fr016 as cidadedest, ufdest.a001 as ufdest
, form.fr020 as dtentregasug, form.fr021 as dtentregaprog, form.fr022 as dtentregareal, form.fr033 as VL_Frete
, form.fr023 as ordeminterna, tpmovimentacao.fr001 as Tipo_solicitação
, case form.fr042 when 1 then 'Frota interna' when 2 then 'Transportadora' else '' end as tptransporte
, case form.fr042 when 1 then form.fr043 +' | '+ form.fr044  when 2 then form.fr035 else '' end as transportador
, case form.fr045 when 1 then 'Sim' else 'Não' end transf_entre_plantas
, grid.fr001 as cod_pedido, grid.fr002 as NotaFiscal , grid.fr003 as Descricao, grid.fr010 as PesoTotal, grid.fr007 as ValorTotal, grid.fr008 as TtPallet, grid.fr009 as QTD_Volume
, grid.fr011 as ONU, grid.fr013 as Classe, grid.fr015 as Temperatura

from DYNsolfrete form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNai001uf uforig on form.OIDABCM8HDQXDSPPAM = uforig.oid
left join DYNai001uf ufdest on form.OIDABCXL0LYZDMLX6C = ufdest.oid
left join DYNsolfrete01 grid on grid.OIDABC48UFLJ6RGD63 = form.oid
left join DYNsolfrete04  tpmovimentacao on form.OIDABCUU7LKUQ8K4U9 = tpmovimentacao.oid

where wf.cdprocessmodel = 4922
