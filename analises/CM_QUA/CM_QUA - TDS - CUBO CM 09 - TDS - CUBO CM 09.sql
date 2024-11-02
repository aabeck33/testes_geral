Select wf.idprocess, wf.NMUSERSTART as iniciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, wf.dtstart as dtabertura
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, cast(coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCIQeABC45y = form.oid FOR XML PATH('')), 4,99000)), 'NA') as varchar(max)) as listaprodlote --listaprod--
, case form.tds112 when 0 then 'Não' when 1 then 'Sim' end as impactliberalote
, case form.tds106 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_regulatorio
, case when form.tds004 = 1 then '' else form.tds007 end as lotestemp
, case form.tds004 when 1 then 'Permanente' when 2 then 'Temporária' end as classific
, case form.tds024 when 0 then 'Não' when 1 then 'Sim' end as materialprod
, case form.tds001 when 0 then 'Não' when 1 then 'Sim' end as impactterc
, case form.tds013 when 0 then 'Não' when 1 then 'Sim' end as avalcli
, case form.tds003 when 0 then 'Não' when 1 then 'Sim' end as emergencial
, case form.tds011 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_validacao
, case form.tds012 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_qualificacao
, case form.tds105 when 0 then 'Não' when 1 then 'Sim' end as tpimpacto_estabiliadde
, case form.tds109 when 1 then 'Sim' when 2 then 'Não' end as info1lote
, areamud.tbs001 as areamudanca, 'NA' as areainiciadora, unid.tbs001 as unidade
, form.tds002 as nmterceiro, form.tds017 as nmaprovaremud
, case form.tds016 when 1 then 'Crítico' when 2 then 'Não crítico' end as critini
, case form.tds107 when 1 then 'Sim' when 2 then 'Não' end as mbr
, case form.tds108 when 1 then 'Melhoria' when 2 then 'Atualização obrigatória' end as tpmbr
, cast(coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs040 where OIDABC1pFABCwh3 = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as varchar(1000)) as listaclientes --listaclientes--
, cast(coalesce((select substring((select ' | '+ tds001 +' - '+ tds002 +' - '+ format(tds003,'dd/MM/yyyy') as [text()] from DYNtds043 where OIDABC8eEABCZHc = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as varchar(1000)) as listaregulatórios --listaregulatórios--

, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left outer join gnrevisionstatus gnrev on (wf.cdstatus = gnrev.cdrevisionstatus)
left join DYNtbs039 areamud on areamud.oid = form.OIDABCk8DABCghk
left join DYNtbs001 unid on unid.oid = form.OIDABCVrhABCPrY

where cdprocessmodel=1
