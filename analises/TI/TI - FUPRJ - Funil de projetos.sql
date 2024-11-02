Select wf.idprocess, wf.NMUSERSTART as iniciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, form.govprj004 as respPrj, dep.nmdepartment as depRespPrj, form.govprj007 as dtIniPla, form.govprj008 as dtFimPlan, form.govprj011 as valor, form.govprj012 as ROI
, case form.govprj024 when 1 then 'SOX' else 'Não SOX' end as sox
, case form.govprj025 when 1 then 'BPx' else 'Não BPx' end as BPx
, clas.clprj001 as classificacao, tpproj.tpprj001 as tipoProj
, (select max(GOVPRJ2004) from DYNgovprj2 where form.oid = OIDABCINfABCN1Y) as numReport
, (select top 1 GOVPRJ2001 from DYNgovprj2 where form.oid = OIDABCINfABCN1Y and GOVPRJ2001 in (select max(GOVPRJ2001) from DYNgovprj2 where form.oid = OIDABCINfABCN1Y) order by GOVPRJ2004) as dtReport
, (select top 1 case GOVPRJ2002 when 1 then 'Verde' when 2 then 'Amarelo' when 3 then 'Vermelho' end from DYNgovprj2 where form.oid = OIDABCINfABCN1Y and GOVPRJ2001 in (select max(GOVPRJ2001) from DYNgovprj2 where form.oid = OIDABCINfABCN1Y) order by GOVPRJ2004) as StatusReport
, (select max(GOVPRJ1004) from DYNgovprj1 where form.oid = OIDABCvoLABCFR6) as numAval
, (select top 1 GOVPRJ1001 from DYNgovprj1 where form.oid = OIDABCvoLABCFR6 and GOVPRJ1001 in (select max(GOVPRJ1001) from DYNgovprj1 where form.oid = OIDABCvoLABCFR6) order by GOVPRJ1004) as dtAval
, (select top 1 case GOVPRJ1002 when 1 then 'Verde' when 2 then 'Amarelo' when 3 then 'Vermelho' end from DYNgovprj1 where form.oid = OIDABCvoLABCFR6 and GOVPRJ1001 in (select max(GOVPRJ1001) from DYNgovprj1 where form.oid = OIDABCvoLABCFR6) order by GOVPRJ1004) as StatusAval
, (select struc.nmstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2) as nmatvatual
, (select format(struc.dtenabled,'dd/MM/yyyy') from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2) as dtiniatvatual
, (select format(struc.dtestimatedfinish,'dd/MM/yyyy') from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2) as przatvatual
, (select executor from (SELECT case when HIS.NMUSER is null then HIS.nmrole else HIS.NMUSER end as executor
FROM WFHISTORY HIS
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and str.idstruct = 
(select struc.idstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2)
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
WHERE  his.idprocess = wf.idobject
and HIS.DTHISTORY+HIS.TMHISTORY = (
select max(HIS1.DTHISTORY+HIS1.TMHISTORY)
FROM WFHISTORY HIS1
inner JOIN WFSTRUCT STR1 ON HIS1.IDSTRUCT=STR1.IDOBJECT and str1.idstruct = 
(select struc.idstruct from wfstruct struc where struc.idprocess = wf.idobject and struc.fgstatus = 2)
LEFT OUTER JOIN WFACTIVITY WFA1 ON STR1.IDOBJECT = WFA1.IDOBJECT
WHERE  his1.idprocess = wf.idobject
)) his) as executatvatual
, case when (select cdleader from aduser where nmuser = form.govprj004) in (1175, 4, 954, 4296) or form.govprj004 = 'Guilhermo Cintra Fragelli' then 'Sistemas'
       when (select cdleader from aduser where nmuser = form.govprj004) in (672, 1681) or form.govprj004 = 'Alexandre Correa Lima' then 'Infraestrutura'
       else 'Não TI'
end as setorTI
, format(prjaval.govprj1001,'dd/MM/yyyy') as dtAvalia, prjaval.govprj1003 as avalComent, prjaval.govprj1004 as seqaval
, format(prjrep.govprj2001,'dd/MM/yyyy') as dtRep, prjrep.govprj2003 as repComent, prjrep.govprj2004 as seqrep
, 1 as quantidade
from DYNgovprj form
inner join GNFORMREG reg on reg.OIDENTITYREG = form.OID
inner join GNFORMREGGROUP grop on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP
inner join WFPROCESS wf on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
left join aduser usr on usr.nmuser = form.govprj004
left join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
left join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
left join DYNclprj clas on form.OIDABCcIrABCkYi = clas.oid
left join DYNtpprj tpproj on form.OIDABCz89ABCjeR = tpproj.oid
left join DYNgovprj1 prjaval on form.oid = prjaval.OIDABCvoLABCFR6
left join DYNgovprj2 prjrep on form.oid = prjrep.OIDABCINfABCN1Y
where wf.cdprocessmodel=1316
