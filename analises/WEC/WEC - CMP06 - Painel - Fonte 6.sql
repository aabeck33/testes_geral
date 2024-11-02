select idprocess + quem as quem, avg(diasestimado) as previsto, avg(diasreal) as realizado
from (
select quantidade, diasestimado, diasreal
, case substring(idprocess, 1, charindex('-',idprocess))
    when 'GERCONC-' then 'GERCONSEC-' else substring(idprocess, 1, charindex('-',idprocess)) end idprocess
, case when quem is null then 'Total' else quem end quem
from (
select idprocess, quem, sum(distinct quantidade) as quantidade, sum(distinct diasestimado) as diasestimado, sum(distinct diasreal) as diasreal
from (
Select wf.idprocess, wf.dtfinish, struc.DTENABLED, struc.DTESTIMATEDFINISH, struc.DTEXECUTION
, datediff(dd,struc.DTENABLED,struc.DTESTIMATEDFINISH) as diasestimado
, case when (datediff(dd,struc.DTENABLED,struc.DTEXECUTION) = 0) then 1 else datediff(dd,struc.DTENABLED,struc.DTEXECUTION) end as diasreal
, case when struc.idstruct in ('Atividade16119163923431','Atividade168410214599','Atividade16102711203529')
                           then 'Requisitante'
		when struc.idstruct in ('Decisão1951410726769','Decisão1951410124977','Decision181017144253360')
                           then 'Aprovador Técnico'
		when struc.idstruct in ('Atividade1612714493380','Decisão16127145213103','Decisão1696121919398','Atividade161281447041','Atividade16920163737407','Atividade16119164416308','Decisão1612614385612')
                           then 'Gestor do Contrato'
		when struc.idstruct in ('Decisão1696121412176','Atividade16920164057329','Atividade16920164858885','Decisão16119164313782','Atividade16126141818467')
                           then 'Jurídico'
       when struc.idstruct in ('Atividade16819124838176','Atividade1684133947305','Atividade16819125923303','Atividade16127145153125','Atividade16127145159707','Atividade17124103318911','Atividade1612714533177','Atividade1612814472837','Atividade16127145318908','Decisão1812213523878','Decisão1831132945259','Decisão18122135258564','Atividade161111103336346','Decision197115357474','Decision197115351995','Decision197115353790','Decisão1812213523878','Decision1971153515198','Decision1971153511389','Decisão18122135258564','Decision1971153522516')
                           then 'Compras'
       when struc.idstruct in ('Atividade1612714843817','Atividade1666153353560','Atividade161049385571','Atividade161111103422527')
                           then 'Assinatura'
       when struc.idstruct in ('Decisão191210135022969','Decisão19121013525163','Decisão16102511415448','Decisão166614406373','Decisão166614415242','Decisão16920164138189','Decisão16920164041982','Decisão1692016412130','Decisão16920164130446','Decisão16920165113328','Decisão161025131858874','Decisão16119164028957','Decisão16119164033806','Decisão16119164045259','Decisão181221121914','Decisão191210145235167','Decisão19121014289244','Decisão191210143220611')
                           then 'Aprovadores'
		when struc.idstruct in ('Atividade169612214299','Atividade166615352732','Atividade1611916433297','Atividade171121417254')
                           then 'Finalização'
       else 'N/A'
  end as quem
, 1 as quantidade
from DYNcon001 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (wf.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and his.fgtype = 9
inner JOIN WFSTRUCT struc ON HIS.IDSTRUCT = struc.IDOBJECT and struc.idprocess = wf.idobject and struc.fgstatus = 3
where (wf.cdprocessmodel = 2808 or wf.cdprocessmodel = 2909 or wf.cdprocessmodel = 2951)
and wf.fgstatus = 4 and gnrev.NMREVISIONSTATUS <> 'Cancelado'
) _sub
group by idprocess, quem
with rollup
) __sub
where idprocess is not null) ___sub
where quem <> 'N/A'
group by idprocess, quem
