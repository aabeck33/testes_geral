select wf.idprocess, wf.nmprocess, wf.dtstart, wf.NMUSERSTART as iniciador, form.crp008 as unidade
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as status_processo
, case form.crp001 when 1 then 'Requisição de pessoal' when 2 then 'Movimentação de pessoal' when 3 then 'Alteração de Centro de Custo' when 4 then 'Desligamento' end as tp1

, case form.crp064 when 1 then 'Aumento salarial' when 2 then 'Promoção' when 4 then 'Transferência ou Alteração de Cargo' end as tp1b
, case form.crp063 when 1 then 'Substituição sem Aumento de Salário' when 2 then 'Substituição com Aumento de salário' when 3 then 'Aumento de quadro' end as tp2b
, case
         when dir01.crp001 is not null then dir01.crp001
		 when dir02.crp001 is not null then dir02.crp001
		 when form.crp051 is not null then form.crp051
		 else null
 end as Diretoria
, form.crp121 as comentario

, gnrev.NMREVISIONSTATUS as status
, 1 as quantidade
from DYNrhcp1 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNcrp01dir  dir01 on dir01.oid = form.OIDABCUPU5NTKV2TKY
left join DYNcrp01dir  dir02 on dir02.oid = form.OIDABCHY0V3JFCNPXB
left join DYNcrp01dir  dir03 on dir03.oid = form.OIDABCFJNV2LZCSNAT

where wf.idprocess like '%55RH01-%'
