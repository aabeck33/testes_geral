Select
        form.p001 as Peril_acesso,
        p002 as Equipe_1,
        p008 as Equipe_2,
        p003 as PapelFuncional,
		p003b as PapelFuncional2,
		p003c as PapelFuncional3,
        p004 as Grupo_Acesso1,
        p010 as Equipe_Area,
        p006 as Papel_Area,
        p007 as Grupo_acesso3,
        p005 as Grupo_acesso2,
        unidade_s.sigla as Sigla_unidade,
        modulo_s.sigla as Sigla_Processo,
        ab001 as AbreviacaoEQ,
		ab002 as AbreviacaoPF,
        1 as quantidade 
    from
        DYNapefilacess form 
    left join
        DYNsolunid unidade_s 
            on unidade_s.oid = form.OIDABCFUND8BQJSKMX 
    left join
        DYNmodulo modulo_s 
            on modulo_s.oid = form.OIDABC2BI4S2NXPNEW
