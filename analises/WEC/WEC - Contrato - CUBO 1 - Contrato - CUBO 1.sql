Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, wf.dtstart as dtabertura
, wf.dtfinish as dtfechamento
, case when form.con042 = '' or form.con042 is null then 'N/A' else form.con042 end as contrpai
, coalesce((select substring((select ' | '+ wff.idprocess as [text()]
from DYNcon001 formf
inner join gnassocformreg gnff on (gnff.oidentityreg = formf.oid)
inner join wfprocess wff on (wff.cdassocreg = gnff.cdassoc)
inner join aduser usrf on usrf.cduser = wff.cdUSERSTART
inner join aduserdeptpos relf on relf.cduser = usrf.cduser and relf.FGDEFAULTDEPTPOS = 1
inner join addepartment depf on depf.cddepartment = relf.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrevf ON (wff.CDSTATUS = GNrevf.CDREVISIONSTATUS)
where wff.cdprocessmodel=2808 and formf.con042 = wf.idprocess FOR XML PATH('')), 4, 4000)), 'NA') as filhos
, case when form.con057 = 1 then '0020 - ANS Industrial Taboão da Serra/SP / ' else '' end +
''+ case when form.con121 = 1 then '0030 - INOVAT Guarulhos/SP / ' else '' end +
''+ case when form.con058 = 1 then '0050 - UQFN Força de Vendas / ' else '' end +
''+ case when form.con059 = 1 then '0050 - UQFN Industrial Brasília/DF / ' else '' end +
''+ case when form.con060 = 1 then '0052 - UQFN Industrial Pouso Alegre/MG / ' else '' end +
''+ case when form.con061 = 1 then '0053 - UQFN Industrial Embu Guaçu/SP / ' else '' end +
''+ case when form.con062 = 1 then '0055 - UQFN Centro Administrativo / ' else '' end +
''+ case when form.con063 = 1 then '0056 - UQFN Gráfica ArtPack/SP / ' else '' end +
''+ case when form.con127 = 1 then '0040 - UQ Ind. Gráfica e de Emb. Ltda/MG / ' else '' end +
''+ case when form.con064 = 1 then '0058 - UQFN Industrial Bthek/BF / ' else '' end +
''+ case when form.con065 = 1 then '0059 - UQFN Centro de Distribuição/MG / ' else '' end +
''+ case when form.con126 = 1 then '0059 - UQFN Centro de Distribuição/MG / ' else '' end +
''+ case when form.con066 = 1 then '0060 - F&F Distribuidora de Produtos Farmacêuticos / ' else '' end +
''+ case when form.con135 = 1 then 'Claris / ' else '' end +
''+ case when form.con125 = 1 then 'RobFerma / ' else '' end +
''+ case when form.con137 = 1 then '0500 - UQFN Goiânia/GO / ' else '' end +
''+ case when form.con129 = 1 then 'Union Agener Inc. / ' else '' end +
''+ case when form.con131 = 1 then 'Union Agener Holding / ' else '' end +
''+ case when form.con068 = 1 then '0090 - Laboratil / ' else '' end +
''+ case when form.con070 = 1 then 'UQFN Bandeirantes' else '' end as empcont
, form.con011 as solicitante, form.con012 as depsol, form.con013 as diraprov, form.con014 as gestcontr, form.con039 as geraprov
, form.con019 as objeto, case form.con071 when 1 then 'Fixo' when 2 then 'Variável' else 'N/A' end valor
, form.con022 as razaosoc, form.con023 as nmfantasia, form.con024 as cnpj, form.con076 as vigencia
, form.con073 as pedsap, form.con074 as contrsap, form.con075 as valinic, form.con026 as valneg, form.con075 - form.con026 as saving
, struc.nmstruct as nmatvatual
, struc.dtenabled as dtiniatvatual
, struc.dtestimatedfinish as przatvatual
, case when HIS.NMUSER is null then HIS.nmrole else HIS.NMUSER end as executatvatual
, combo1.con001 as tipocontr
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DYNcon001espec combo1 on combo1.oid = form.OIDABCzgOABC2Ih
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.fgtype = 6
inner JOIN WFSTRUCT struc ON HIS.IDSTRUCT=struc.IDOBJECT and struc.idprocess = wf.idobject and struc.idstruct <> 'Atividade1576102552943' and struc.fgstatus = 2
and HIS.DTHISTORY+HIS.TMHISTORY = (select max(HIS1.DTHISTORY+HIS1.TMHISTORY) FROM WFHISTORY HIS1 where his1.fgtype = 6 and his1.idprocess = wf.idobject and his1.idstruct = struc.idobject)
where (wf.cdprocessmodel=2808 or wf.cdprocessmodel=2909)
