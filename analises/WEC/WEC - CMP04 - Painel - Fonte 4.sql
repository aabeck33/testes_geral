select
case when substring(case when coluna = 'con057' then ' | 0020 - ANS Industrial Taboão da Serra/SP' else '' end +
  case when coluna = 'con121' then ' | 0030 - INOVAT Guarulhos/SP' else '' end +
  case when coluna = 'con058' then ' | 0050 - UQFN Força de Vendas' else '' end +
  case when coluna = 'con059' then ' | 0050 - UQFN Industrial Brasília/DF' else '' end +
  case when coluna = 'con060' then ' | 0052 - UQFN Industrial Pouso Alegre/MG' else '' end +
  case when coluna = 'con061' then ' | 0053 - UQFN Industrial Embu Guaçu/SP' else '' end +
  case when coluna = 'con062' then ' | 0055 - UQFN Centro Administrativo' else '' end +
  case when coluna = 'con140' then ' | 0054 - Depósito Taboão da Serra/SP' else '' end +
  case when coluna = 'con063' then ' | 0056 - UQFN Gráfica ArtPack/SP' else '' end +
  case when coluna = 'con127' then ' | 0040 - UQ Ind. Gráfica e de Emb. Ltda/MG' else '' end +
  case when coluna = 'con064' then ' | 0058 - UQFN Industrial Bthek/BF' else '' end +
  case when coluna = 'con065' then ' | 0059 - UQFN Centro de Distribuição/MG' else '' end +
  case when coluna = 'con126' then ' | 0059 - UQFN Centro de Distribuição/MG' else '' end +
  case when coluna = 'con066' then ' | 0060 - F&F Distribuidora de Produtos Farmacêuticos' else '' end +
  case when coluna = 'con068' then ' | 0090 - Laboratil' else '' end +
  case when coluna = 'con135' then ' | Claris' else '' end +
  case when coluna = 'con125' then ' | RobFerma' else '' end +
  case when coluna = 'con137' then ' | 0500 - UQFN Goiânia/GO' else '' end +
  case when coluna = 'con129' then ' | Union Agener Inc.' else '' end +
  case when coluna = 'con131' then ' | Union Agener Holding' else '' end +
  case when coluna = 'con070' then ' | UQFN Bandeirantes' else '' end, 4, 500) = '' then 
case coluna
	when 'con001' then '0020 - ANS Industrial Taboão da Serra/SP'
	when 'con120' then '0030 - INOVAT Guarulhos/SP'
	when 'con002' then '0050 - UQFN Força de Vendas'
	when 'con003' then '0050 - UQFN Industrial Brasília/DF'
	when 'con004' then '0052 - UQFN Industrial Pouso Alegre/MG'
	when 'con005' then '0053 - UQFN Industrial Embu Guaçu/SP'
	when 'con006' then '0055 - UQFN Centro Administrativo'
	when 'con139' then '0054 - Depósito Taboão da Serra/SP'
	when 'con007' then '0056 - UQFN Gráfica ArtPack/SP'
	when 'con123' then '0040 - UQ Ind. Gráfica e de Emb. Ltda/MG'
	when 'con008' then '0058 - UQFN Industrial Bthek/BF'
	when 'con009' then '0059 - UQFN Centro de Distribuição/MG'
	when 'con122' then '0059 - UQFN Centro de Distribuição/MG'
	when 'con010' then '0060 - F&F Distribuidora de Produtos Farmacêuticos'
	when 'con067' then '0090 - Laboratil'
	when 'con134' then 'Claris'
	when 'con124' then 'RobFerma'
	when 'con136' then '0500 - UQFN Goiânia/GO'
	when 'con128' then 'Union Agener Inc.'
	when 'con130' then 'Union Agener Holding'
	when 'con069' then 'UQFN Bandeirantes'
end else
case coluna
	when 'con057' then '0020 - ANS Industrial Taboão da Serra/SP'
	when 'con121' then '0030 - INOVAT Guarulhos/SP'
	when 'con058' then '0050 - UQFN Força de Vendas'
	when 'con059' then '0050 - UQFN Industrial Brasília/DF'
	when 'con060' then '0052 - UQFN Industrial Pouso Alegre/MG'
	when 'con061' then '0053 - UQFN Industrial Embu Guaçu/SP'
	when 'con062' then '0055 - UQFN Centro Administrativo'
	when 'con140' then '0054 - Depósito Taboão da Serra/SP'
	when 'con063' then '0056 - UQFN Gráfica ArtPack/SP'
	when 'con127' then '0040 - UQ Ind. Gráfica e de Emb. Ltda/MG'
	when 'con064' then '0058 - UQFN Industrial Bthek/BF'
	when 'con065' then '0059 - UQFN Centro de Distribuição/MG'
	when 'con126' then '0059 - UQFN Centro de Distribuição/MG'
	when 'con066' then '0060 - F&F Distribuidora de Produtos Farmacêuticos'
	when 'con068' then '0090 - Laboratil'
	when 'con135' then 'Claris'
	when 'con125' then 'RobFerma'
	when 'con137' then '0500 - UQFN Goiânia/GO'
	when 'con129' then 'Union Agener Inc.'
	when 'con131' then 'Union Agener Holding'
	when 'con070' then 'UQFN Bandeirantes'
end end unidade
, sum(valor) as quantidade
from (
select coluna, valor
from (SELECT idprocess, formj.*
from DYNcon001 formj
   inner join gnassocformreg gnfj on (gnfj.oidentityreg = formj.oid)
   inner join wfprocess wfj on (wfj.cdassocreg = gnfj.cdassoc)
   where wfj.fgstatus = 1 and (wfj.cdprocessmodel=2808 or wfj.cdprocessmodel=2909 or wfj.cdprocessmodel=2951)
) s
unpivot (valor for coluna in (con057, con121, con058, con062, con059, con060, con061, con063, con064, con065, con066, con068, con070)) as tt
where 1 = 1) _sub
group by coluna
