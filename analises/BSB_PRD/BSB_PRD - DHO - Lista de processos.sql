Select wf.idprocess, wf.NMUSERSTART as iniciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, format(wf.dtstart,'dd/MM/yyyy') as dtabertura, datepart(yyyy,wf.dtstart) as dtabertura_ano, datepart(MM,wf.dtstart) as dtabertura_mes
, format(wf.dtfinish,'dd/MM/yyyy') as dtfechamento, datepart(yyyy,wf.dtfinish) as dtfechamento_ano, datepart(MM,wf.dtfinish) as dtfechamento_mes
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
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
, case form.crp001 when 1 then 'Requisição de pessoal' when 2 then 'Alteração de cargos e salários' when 3 then 'Transferência' when 4 then 'Desligamento' end as tipoSolic
, case when (form.crp001 = 1 and form.crp063 = 1) then 'Substituição' when (form.crp001 = 1 and form.crp063 = 2) then 'Aumento de quadro' when (form.crp001 = 1 and form.crp063 = 3) then 'Substituição com aumento de quadro'
       when (form.crp001 = 2 and form.crp064 = 1) then 'Aumento salarial' when (form.crp001 = 2 and form.crp064 = 2) then 'Promoção' when (form.crp001 = 2 and form.crp064 = 3) then 'Alteração de cargo'
       when (form.crp001 = 3 and form.crp065 = 1) then 'Unidade' when (form.crp001 = 3 and form.crp065 = 2) then 'Área (mesma unidade)'
       when (form.crp001 = 4) then '-'
  end as subTipoSolic
, 1 as Quantidade
from DYNrhcp1 form
inner join GNFORMREG reg on reg.OIDENTITYREG = form.OID
inner join GNFORMREGGROUP grop on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP
inner join WFPROCESS wf on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
where wf.cdprocessmodel=86
and (327 in (select usrw.cdleader from wfprocess wfw inner join aduser usrw on usrw.cduser = wfw.cduserstart where wfw.idobject = wf.idobject)
	 or wf.cduserstart = 327)
