select case coluna
            when 'empcont01' then '0020 - ANS Industrial Taboão da Serra/SP'
            when 'empcont03' then '0050 - UQFN Força de Vendas'
            when 'empcont02' then '0030 - INOVAT Guarulhos/SP'
            when 'empcont07' then '0055 - UQFN Centro Administrativo'
            when 'empcont04' then '0050 - UQFN Industrial Brasília/DF'
            when 'empcont05' then '0059 - Centro Logístico Pouso Alegre'
            when 'empcont10' then '0052 - UQFN Industrial Pouso Alegre/MG'
            when 'empcont06' then '0053 - UQFN Industrial Embu Guaçu/SP'
            when 'empcont08' then '0040 - UQ Ind. Gráfica e de Emb. Ltda/MG'
            when 'empcont09' then '0058 - UQFN Industrial Bthek/BF'
            when 'empcont01' then '0059 - UQFN Centro de Distribuição/MG'
            when 'empcont11' then '0060 - F&F Distribuidora de Produtos Farmacêuticos'
            when 'empcont12' then '0090 - Laboratil'
            when 'empcont13' then 'UQFN Bandeirantes'
			when 'empcont14' then 'RobFerma'
			when 'empcont15' then '0010 - UNION AGENER Industrial Augusta\GA'
			when 'empcont16' then 'Union Agener Holding'
			when 'empcont17' then 'Claris'
			when 'empcont18' then '0500 - UQFN Goiânia/GO'
			when 'empcont19' then 'Union Agener Inc.'
			when 'empcont20' then '0054 - Depósito Taboão da Serra/SP'
		end unidade
, sum(valor) as quantidade
from (
        select coluna, valor
        from (  SELECT rev.cdrevision
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71146) then 1 else 0 end) as empcont01
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71147) then 1 else 0 end) as empcont02
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71148) then 1 else 0 end) as empcont03
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71149) then 1 else 0 end) as empcont04
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71155 or atvl.cdvalue = 112803) then 1 else 0 end) as empcont05
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71151) then 1 else 0 end) as empcont06
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71152) then 1 else 0 end) as empcont07
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71153) then 1 else 0 end) as empcont08
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71154) then 1 else 0 end) as empcont09
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71150) then 1 else 0 end) as empcont10
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71156) then 1 else 0 end) as empcont11
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71157) then 1 else 0 end) as empcont12
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71158) then 1 else 0 end) as empcont13
                , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 71159) then 1 else 0 end) as empcont14
               , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 78939) then 1 else 0 end) as empcont15
               , ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 78940) then 1 else 0 end) as empcont16
				, ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 112801) then 1 else 0 end) as empcont17
				, ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 112802) then 1 else 0 end) as empcont18
				, ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 118615) then 1 else 0 end) as empcont19
				, ( case when exists (select atcd.nmattribute 
                    from DCDOCMULTIATTRIB atvl
                    inner join adattribvalue atcd on atcd.cdvalue = atvl.cdvalue
                    where atvl.cdattribute = 354 and atvl.cdrevision = rev.cdrevision and atvl.cdvalue = 118616) then 1 else 0 end) as empcont20
                from dcdocrevision rev
                inner join DCDOCMULTIATTRIB atv on atv.cdrevision = rev.cdrevision
                where rev.fgcurrent = 1 and atv.cdattribute = 354
                group by rev.cdrevision
             ) s
unpivot (valor for coluna in (empcont01,empcont02,empcont03,empcont04,empcont05,empcont06,empcont07,empcont08,empcont09,empcont10,empcont11,empcont12,empcont13,empcont14,empcont15,empcont16)) as tt
where 1 = 1) _sub
group by coluna
