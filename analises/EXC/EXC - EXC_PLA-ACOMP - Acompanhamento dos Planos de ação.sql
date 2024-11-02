select CAST(gntype.IDGENTYPE + CASE WHEN gntype.IDGENTYPE IS NULL THEN NULL ELSE ' - ' END + gntype.NMGENTYPE AS VARCHAR(250)) AS planta
, actp.idactivity as plano, actp.nmactivity as nmplano, coalesce(actp.VLPERCENTAGEM,0) as porcentPlano
, actp.DTstartPLAN as dtInicioPlano_planed, actp.DTFINISHPLAN as dtFimPlano_planed
, actp.DTstart as dtInicioPlano_real, actp.DTFINISH as dtFimPlano_real
, (select nmuser from aduser where cduser=actp.cduser) as RespPlano
, case actp.fgstatus
    when 1 then 'Planejamento'
    when 2 then 'Aprovação do planejamento'
    when 3 then 'Execução'
    when 4 then 'Verificação da eficácia'
    when 5 then 'Encerrado'
    WHEN 6 THEN 'Cancelado' 
    WHEN 7 THEN 'Cancelado' 
    WHEN 8 THEN 'Cancelado' 
    WHEN 9 THEN 'Cancelado' 
    WHEN 10 THEN 'Cancelado' 
    WHEN 11 THEN 'Cancelado'
end as statusPlano
, act.idactivity as idacao, act.nmactivity as nmacao, coalesce(act.VLPERCENTAGEM,0) as porcentAcao
, act.DTstartPLAN as dtInicioAcao_planed, act.DTFINISHPLAN as dtFimAcao_planed
, act.DTstart as dtInicioAcao_real, act.DTFINISH as dtFimAcao_real
, (select nmuser from aduser where cduser=act.cduser) as execAcao
, case act.fgstatus
    when 1 then 'Planejamento'
    when 2 then 'Aprovação do planejamento'
    when 3 then 'Execução'
    when 4 then 'Aprovação da execução'
    when 5 then 'Encerrada'
    WHEN 6 THEN 'Cancelado' 
    WHEN 7 THEN 'Cancelado' 
    WHEN 8 THEN 'Cancelado' 
    WHEN 9 THEN 'Cancelado' 
    WHEN 10 THEN 'Cancelado' 
    WHEN 11 THEN 'Cancelado'
end as statusAcao
, 1 as quantidade
from GNACTIONPLAN plano
inner join gnactivity actp on actp.CDGENACTIVITY = plano.CDGENACTIVITY and actp.cdactivityowner is null
inner join gnactivity act on act.cdactivityowner = actp.cdgenactivity
inner join gnactionplan actpl on act.cdactivityowner = actpl.cdgenactivity
INNER JOIN GNGENTYPE gntype ON gntype.CDGENTYPE = actpl.CDACTIONPLANTYPE
where gntype.CDGENTYPEOWNER = 53
