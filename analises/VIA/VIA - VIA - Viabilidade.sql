Select wf.idprocess as Código, wf.NMUSERSTART iniciador, wf.nmprocess as Título
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, case wf.FGDURATIONUNIT when 1 then 'Em dia' when 2 then 'Em atraso' end as Prazo 
, wf.dtstart, wf.DTESTIMATEDFINISH as Fim_Viablidade, struc.nmstruct as nmatvatual, struc.dtenabled as dtiniatvatual
, struc.dtestimatedfinish as przatvatual
, form.via001 as Dados_Viabilidade, l_mkt.linha as linha_mkt, U_NEG.unidade as Unidade_neg, CATEG.CATEGORIA AS CATEGORIA, fabril.fabril as UnidadeFabril
, form.vib005 as LiderProjeto, form.viab32 as ciclo, form.via020 as ClasseTerapeutica, form.via021 as Regulatorio, form.via022 as Classificacao, form.via023 as PrincipioAtivo
, form.via024 as Apresentacao, form.via025a as ProjecaoRecBruta, form.via026a as ProjecaoMargBruta, form.via027a as LucroOperacRano, form.via028 as Investimento, form.via029 as TIR
, form.via030 as PayBack, form.via031a as LucroOperacional, form.via036a as DefinicaoEstrateg, form.via033a as Tecnico, form.via034a as CustoTTproj, form.via36b as MediaPonderada
, wfa.NMUSER as executor, wfa.nmrole as papel_funcional
--, case when wfa.NMUSER is null then wfa.nmrole else wfa.NMUSER end as executatvatual
, coalesce((select dep1.iddepartment +' - '+ dep1.nmdepartment from aduser usr1 inner join aduserdeptpos rel1 on rel1.cduser = usr1.cduser and rel1.fgdefaultdeptpos = 1 inner join addepartment dep1 on dep1.cddepartment = rel1.cddepartment where usr1.cduser = wfa.cdUSER), wfa.nmrole) as executarea


, 1 as quantidade
from DYNviab form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
left join DYNauxunidade22 U_NEG on U_NEG.oid = form.OIDABCURIPIRHKBTLU --Un.negocio
left join DYNauxlmktvia L_MKT on L_MKT.oid = form.OIDABC3ZN1VL6BBY27 --linha_mkt
left join DYNauxcategvia CATEG on CATEG.oid = form.OIDABCGHVZZULMHRZU --CATEGORIA
left join DYNauxunifabrivia FABRIL on FABRIL.oid = form.OIDABCJY7ZPHTTSAF9 --UnidadeFabril


inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.fgtype = 6
inner JOIN WFSTRUCT struc ON HIS.IDSTRUCT = struc.IDOBJECT and struc.idprocess = wf.idobject and struc.fgstatus = 2
and HIS.DTHISTORY+HIS.TMHISTORY = (select max(HIS1.DTHISTORY+HIS1.TMHISTORY) FROM WFHISTORY HIS1 where his1.fgtype = 6 and his1.idprocess = wf.idobject and his1.idstruct = struc.idobject)
inner join wfactivity wfa on wfa.idobject=struc.idobject
where wf.cdprocessmodel=5129 
and wf.fgstatus = 1
