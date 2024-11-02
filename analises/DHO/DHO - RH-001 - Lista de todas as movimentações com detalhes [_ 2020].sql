select wf.idprocess, wf.nmprocess, wf.dtstart+wf.tmstart as dtinicio, wf.dtfinish+wf.tmfinish as dtfim, wf.nmuserstart
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
, (SELECT wfs.nmstruct FROM WFSTRUCT wfs WHERE wfs.fgstatus = 2 and wfs.idprocess=wf.idobject) as atvAtual
, case form.crp001
when 1 then 'Requisição de pessoal'
when 2 then 'Movimentação de Pessoal'
when 3 then 'Alteração de Centro de Custo'
when 4 then 'Desligamento'
end as tipo
, case form.crp001
when 1 then
case form.crp063
when 1 then 'Substituição sem Aumento de Salário'
when 2 then 'Substituição com Aumento de salário'
when 3 then 'Aumento de quadro'
else 'N/A'
end
when 2 then
case form.crp064
when 1 then 'Aumento salarial'
when 2 then 'Promoção'
when 4 then 'Transferência ou Alteração de Cargo'
else 'N/A'
end
else 'N/A'
end as acao
, case form.crp001
when 1 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCXJCABC8V3)
when 2 then
case form.crp064
when 1 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCAF9ABCOFJ)
when 2 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCQTNABCWDT)
when 4 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCQTNABCWDT)
else 'N/A'
end
when 3 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCQTNABCWDT)
when 4 then (select CRP001 from DYNtrcp01unid where oid = form.OIDABCEIDABCBSE)
end as unidade
, case form.crp001
when 1 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCUPU5NTKV2TKY)
when 2 then case form.crp064
when 1 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCHY0V3JFCNPXB)
when 2 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCZV5YDZ2ORHTQ)
when 4 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCZV5YDZ2ORHTQ)
else 'N/A'
end
when 3 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCZV5YDZ2ORHTQ)
when 4 then (select CRP001 from DYNcrp01dir where oid = form.OIDABCFJNV2LZCSNAT)
end as diretoria
, case form.crp001
when 1 then form.CRP010
when 2 then case form.crp064
when 1 then form.CRP032
when 2 then form.CRP037
when 4 then form.CRP037
else 'N/A'
end
when 3 then form.CRP037
when 4 then form.CRP047
end as departamento
, case form.crp001
when 1 then form.CRP009
when 2 then case form.crp064
when 1 then form.CRP055
when 2 then form.CRP056
when 4 then form.CRP056
else 'N/A'
end
when 3 then form.CRP056
when 4 then form.CRP046
end as cc_contabil
, case form.crp001
when 1 then form.CRP012
when 2 then case form.crp064
when 1 then form.CRP031
when 2 then form.CRP036
when 4 then form.CRP036
else 'N/A'
end
when 3 then form.CRP036
when 4 then form.CRP058
end as cargo
, form.crp236 as escalona1
, form.crp237 as escalona2
, form.crp238 as escalona3
, case form.crp001
when 1 then form.CRP120
when 2 then form.CRP087
when 3 then null
when 4 then null
end as salario
, 1 as quant
from DYNrhcp1 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
where wf.cdprocessmodel = 86
and datepart(yyyy,wf.dtstart) > 2020
