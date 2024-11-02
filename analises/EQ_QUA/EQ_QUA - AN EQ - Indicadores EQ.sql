Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, wf.dtstart, gnrev.NMREVISIONSTATUS as status, wf.nmprocess
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS statusproc
, (select atv.nmattribute from WFPROCATTRIB atrI inner join adattribvalue atv on atv.cdvalue = atrI.cdvalue where atrI.cdattribute = 124 and atrI.idprocess = wf.idobject) as Tipo_EQ
, (select atv.nmattribute from WFPROCATTRIB atrI inner join adattribvalue atv on atv.cdvalue = atrI.cdvalue where atrI.cdattribute = 126 and atrI.idprocess = wf.idobject) as Criticid
, (select atv.nmattribute from WFPROCATTRIB atrI inner join adattribvalue atv on atv.cdvalue = atrI.cdvalue where atrI.cdattribute = 122 and atrI.idprocess = wf.idobject) as Area_resp
, (select atrI.nmstring from WFPROCATTRIB atrI where atrI.cdattribute = 179 and atrI.idprocess = wf.idobject) as Responsavel_EQ
, (select atrI.nmstring from WFPROCATTRIB atrI where atrI.cdattribute = 172 and atrI.idprocess = wf.idobject) as Aprovador_ind
, (select atrI.dtdate from WFPROCATTRIB atrI where atrI.cdattribute = 194 and atrI.idprocess = wf.idobject) as Prazo_con_Eq
, (select atv.nmattribute from WFPROCATTRIB atrI inner join adattribvalue atv on atv.cdvalue = atrI.cdvalue where atrI.cdattribute = 137 and atrI.idprocess = wf.idobject) as Verif_eficacia
, (select atrI.nmstring from WFPROCATTRIB atrI where atrI.cdattribute = 136 and atrI.idprocess = wf.idobject) as Dias_verif
, cast(coalesce((select substring((select ' | '+ attv.nmattribute as [text()] from ADATTRIBVALUE attv where cdattribute = 196 and cdvalue in (select wfv.cdvalue from WFPROATTMULTIVALUE wfv where wfv.cdattribute = 196 and idprocattrib =
(select wfa.idobject from WFPROCATTRIB wfa where wfa.idprocess = wf.idobject and cdattribute = 196)) FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as cliente
, case when datediff(day, STR.dtestimatedfinish, getdate()) > 0 then 'Atraso' else 'Em dia'  end prazo_exe
, plano.idactivity as Plano_id, plano.nmactivity as Plano_nm
, priori.nmevalresult, gntypepl.nmgentype as nmtipoplano, gntypepl.idgentype as idtipoplano, STR.nmstruct as nmatv_atual
, case plano.fgstatus
     when  1 then 'Em planejamento' when  2 then 'Em aprovavação do planejamento'  when  3 then 'Em execução' when  4 then 'Em aprovação da execução'  when  5 then 'Encerrado'  when  6 then 'Cancelado' when  7 then 'Cancelado' when  9 then 'Cancelado' when 10 then 'Cancelado' when 11 then 'Cancelado' end as Plano_st
, (select nmuser from aduser where cduser = acao.cduser) as Acao_exec
, (select dep.nmdepartment from aduser usr inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.fgdefaultdeptpos = 1 inner join addepartment dep on dep.cddepartment = rel.cddepartment where usr.cduser = acao.cduser) as Acao_area
, acao.idactivity as idAcao, acao.nmactivity as Acao_nm
, acao.dtstartplan as Acao_inicp, acao.dtfinishplan as Acao_fimpo, acao.dtstart as Acao_inicr, acao.dtfinish as Acao_fimr
, gntypeac.nmgentype as nmtipoacao, gntypeac.idgentype as idtipoacao
, case acao.fgstatus
     when  1 then 'Em planejamento' when  2 then 'Em aprovavação do planejamento' when  3 then 'Em execução' when  4 then 'Em aprovação da execução' when  5 then 'Encerrada' when  6 then 'Cancelada' when  7 then 'Cancelada' when  9 then 'Cancelada' when 10 then 'Cancelada' when 11 then 'Cancelada' end as Acao_st
, (cast(substring((select ', '+ gnact.idactivity as [text()] from GNACTIVITYLINKS pred
inner join gnactivity gnact on pred.cdpredecessor = gnact.cdgenactivity
where pred.cdactivity = acao.cdgenactivity
FOR XML PATH('')), 3, 250) as varchar(255))) as acao_predecessora
, case
    when (plano.fgstatus = 3 and acao.fgstatus = 3 and (select count(pred2.cdactivity) from GNACTIVITYLINKS pred2 where pred2.cdactivity = acao.cdgenactivity) = 0)
         or (plano.fgstatus = 3 and acao.fgstatus = 3 and (select min(gnact.fgstatus) from GNACTIVITYLINKS pred 
             inner join gnactivity gnact on pred.cdpredecessor = gnact.cdgenactivity where pred.cdactivity = acao.cdgenactivity)  > 4) then 'Sim'
    else 'Não'
end as acao_disp
, case when aprov.fgapprov = 1 then 'Sim' when aprov.fgapprov = 2 then 'Não' end as Apr_acao
, case when (coalesce(aprov.nmuserapprov, aprov.nmuser)) is not null then (coalesce(aprov.nmuserapprov, aprov.nmuser)) end as Apr_exec
, aprov.dtapprov as Apr_dt, aprov.cdcycle as qtdCiclos

from wfprocess wf

INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
inner JOIN gnactivity gnact ON wf.CDGENACTIVITY = gnact.CDGENACTIVITY
inner join gnassocactionplan stpl on stpl.cdassoc = gnact.cdassoc
inner JOIN gnactionplan gnpl ON gnpl.cdgenactivity = stpl.cdactionplan
INNER JOIN GNGENTYPE gntypepl ON gntypepl.CDGENTYPE = gnpl.CDACTIONPLANTYPE
inner JOIN gnactivity plano ON gnpl.cdgenactivity = plano.cdgenactivity
inner join gnactivity acao on plano.cdgenactivity = acao.cdactivityowner
inner join GNTMCACTIONPLAN TMCPLAN on TMCPLAN.CDGENACTIVITY = acao.CDGENACTIVITY
LEFT OUTER JOIN GNGENTYPE gntypeac ON (gntypeac.CDGENTYPE=TMCPLAN.CDACTIONPLANTYPE)
inner join GNEVALRESULTUSED GNEVALRESACT ON GNEVALRESACT.CDEVALRESULTUSED = plano.CDEVALRSLTPRIORITY
inner join GNEVALRESULT priori on priori.CDEVALRESULT=GNEVALRESACT.CDEVALRESULT
left join gnvwapprovresp aprov on aprov.cdapprov = acao.cdexecroute and cdprod=174
      and ((aprov.fgpend = 2 or (fgpend is null and fgapprov is null))
      or (fgpend = 1 and fgapprov is null)) and aprov.cdcycle = (select max(cdcycle) from gnvwapprovresp aprov2 where aprov2.cdprod = aprov.cdprod and aprov2.cdapprov = aprov.cdapprov)

where cdprocessmodel=28

