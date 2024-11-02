Select wf.dtstart as dtabertura, wf.idprocess, form.con011 as solic,  form.con012 as depsol, form.con026 as valor
, (select dep.nmdepartment from addepartment dep
   inner join aduserdeptpos rel on rel.cddepartment = dep.cddepartment and rel.FGDEFAULTDEPTPOS = 1 and rel.CDUSER = (select usr.cduser from aduser usr where usr.idlogin = form.con041)) as diretoria
, case when
            substring(case when form.con057 = 1 then ' | 0020 - ANS Industrial Taboão da Serra/SP' else '' end +
                      case when form.con121 = 1 then ' | 0030 - INOVAT Guarulhos/SP' else '' end +
                      case when form.con058 = 1 then ' | 0050 - UQFN Força de Vendas' else '' end +
                      case when form.con059 = 1 then ' | 0050 - UQFN Industrial Brasília/DF' else '' end +
                      case when form.con060 = 1 then ' | 0052 - UQFN Industrial Pouso Alegre/MG' else '' end +
                      case when form.con061 = 1 then ' | 0053 - UQFN Industrial Embu Guaçu/SP' else '' end +
                      case when form.con062 = 1 then ' | 0055 - UQFN Centro Administrativo' else '' end +
                      case when form.con063 = 1 then ' | 0056 - UQFN Gráfica ArtPack/SP' else '' end +
                      case when form.con127 = 1 then ' | 0040 - UQ Ind. Gráfica e de Emb. Ltda/MG' else '' end +
                      case when form.con064 = 1 then ' | 0058 - UQFN Industrial Bthek/BF' else '' end +
                      case when form.con126 = 1 then ' | 0059 - UQFN Centro de Distribuição/MG' else '' end +
                      case when form.con065 = 1 then ' | 0059 - Centro Logístico Pouso Alegre/MG' else '' end +
                      case when form.con066 = 1 then ' | 0060 - F&F Distribuidora de Produtos Farmacêuticos' else '' end +
                      case when form.con068 = 1 then ' | 0090 - Laboratil' else '' end +
                      case when form.con124 = 1 then ' | RobFerma' else '' end +
                      case when form.con135 = 1 then ' | Claris' else '' end +
                      case when form.con137 = 1 then ' | 0500 - UQFN Goiânia/GO' else '' end +
                      case when form.con129 = 1 then ' | Union Agener Inc.' else '' end +
                      case when form.con131 = 1 then ' | Union Agener Holding' else '' end +
                      case when form.con070 = 1 then ' | UQFN Bandeirantes' else '' end, 4, 500) = '' then 'Sem DRAC'
       else
            substring(case when form.con057 = 1 then ' | 0020 - ANS Industrial Taboão da Serra/SP' else '' end +
                      case when form.con121 = 1 then ' | 0030 - INOVAT Guarulhos/SP' else '' end +
                      case when form.con058 = 1 then ' | 0050 - UQFN Força de Vendas' else '' end +
                      case when form.con059 = 1 then ' | 0050 - UQFN Industrial Brasília/DF' else '' end +
                      case when form.con060 = 1 then ' | 0052 - UQFN Industrial Pouso Alegre/MG' else '' end +
                      case when form.con061 = 1 then ' | 0053 - UQFN Industrial Embu Guaçu/SP' else '' end +
                      case when form.con062 = 1 then ' | 0055 - UQFN Centro Administrativo' else '' end +
                      case when form.con063 = 1 then ' | 0056 - UQFN Gráfica ArtPack/SP' else '' end +
                      case when form.con127 = 1 then ' | 0040 - UQ Ind. Gráfica e de Emb. Ltda/MG' else '' end +
                      case when form.con064 = 1 then ' | 0058 - UQFN Industrial Bthek/BF' else '' end +
                      case when form.con126 = 1 then ' | 0059 - UQFN Centro de Distribuição/MG' else '' end +
                      case when form.con065 = 1 then ' | 0059 - Centro Logístico Pouso Alegre/MG' else '' end +
                      case when form.con066 = 1 then ' | 0060 - F&F Distribuidora de Produtos Farmacêuticos' else '' end +
                      case when form.con068 = 1 then ' | 0090 - Laboratil' else '' end +
                      case when form.con124 = 1 then ' | RobFerma' else '' end +
                      case when form.con135 = 1 then ' | Claris' else '' end +
                      case when form.con137 = 1 then ' | 0500 - UQFN Goiânia/GO' else '' end +
                      case when form.con129 = 1 then ' | Union Agener Inc.' else '' end +
                      case when form.con131 = 1 then ' | Union Agener Holding' else '' end +
                      case when form.con070 = 1 then ' | UQFN Bandeirantes' else '' end, 4, 500)
       end as unidade
, form.con022 as RazaoSocialContraria, form.con045 as tipoAtividade, case when wf.cdprocessmodel <> 2951 then combo1.con001 else 'Distrato' end as tipocontr
, wf.nmprocess as nomeProcesso, form.con019 as Objeto
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, gnrev.NMREVISIONSTATUS as RespAcao
, cast(coalesce((select substring((select ' | '+ struc.nmstruct as [text()] from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as nmatvatual
, cast(coalesce((select substring((select ' | '+ coalesce(wfa.nmuser,wfa.nmrole) as [text()] from wfstruct struc
                 LEFT OUTER JOIN WFACTIVITY WFA ON STRuc.IDOBJECT = WFA.IDOBJECT where struc.idprocess = wf.idobject and struc.fgstatus = 2
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as executores
, form.con013 as diretorapr
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.idstruct in ('Decisão1696121412176', 'Decisão16119164313782') and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as advogado
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.idstruct in ('Atividade161111103336346', 'Atividade16819124838176', 'Atividade1684133947305', 'Atividade16819125923303') 
and str.idprocess=wf.idobject and str.idobject = wfa.idobject
and str.DTENABLED + str.TMENABLED = (SELECT max(str1.DTENABLED+str1.TMENABLED) FROM WFSTRUCT STR1, WFACTIVITY WFA1
   WHERE str1.idstruct in ('Atividade161111103336346', 'Atividade16819124838176', 'Atividade1684133947305', 'Atividade16819125923303') 
and str1.idprocess=wf.idobject and str1.idobject = wfa1.idobject)) as comprador
, cast(coalesce((select substring((select ' | '+ rev.iddocument as [text()] from dcdocumentattrib atrel
                 inner join dcdocrevision rev on rev.cdrevision = atrel.cdrevision
                 where atrel.cdrevision = rev.cdrevision and ((atrel.cdattribute = 230 or atrel.cdattribute = 231) and nmvalue = wf.idprocess) FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as contrato
, 'Em Desenvolvimento' as contratoVigente
, 'Em Desenvolvimento' as vigencia
, 'Em Desenvolvimento' as status
, 'Em Desenvolvimento' as regularizacaoAndamento
, 'Em Desenvolvimento' as prazoTermino
, 'Em Desenvolvimento' as Contratante
, 'Em Desenvolvimento' as Contratada
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DYNcon001espec combo1 on combo1.oid = form.OIDABCzgOABC2Ih
where wf.fgstatus <= 5
