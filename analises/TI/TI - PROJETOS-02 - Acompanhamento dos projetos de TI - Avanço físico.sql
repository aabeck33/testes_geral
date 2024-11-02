select P.NMIDTASK AS idprojeto, P.NMTASK AS nmprojeto
, case p.FGPHASE
    when 1 then 'Planejamento'
    when 2 then 'Execução'
    when 3 then 'Verificação'
    when 4 then 'Encerrado'
    when 5 then 'Aprovação'
    when 6 then 'Suspenso'
    when 7 then 'Cancelado'
end fase
, 1 as quantidade
, p.DTPLANST as iniplanproj, p.DTPLANEND as fimplanproj
, p.DTREPLST as inireplanproj, p.DTREPLEND as fimreplanproj
, p.DTACTST as inirealproj, p.DTACTEND as fimrealproj
, coalesce(pontoplan, 100) as pontoplan, pontoreplan, coalesce(pontoreal, 0) as pontoreal
, progr.nmidtask as programa, progr.nmtask as nmprograma
from PRTASK P
inner join prtasktype pty on pty.cdtasktype = p.cdtasktype
inner join prtask prog on prog.nmidtask = p.nmidtask and prog.fgtasktype = 5 and prog.cdtasktype = 4
inner join prtask progr on progr.cdtask = prog.CDBASETASK
inner join (select idprojeto
, ROUND((sum(duraplan) / sum(durplanact)) * 100,0,0) as pontoplan
, ROUND((sum(durareplan) / sum(durreplanact)) * 100,0,0) as pontoreplan
, ROUND((sum(durareal) / sum(durrealact)) * 100,0,0) as pontoreal
from (select P.NMIDTASK AS idprojeto
, act.QTPLANDUR as durplanact
, act.QTREPLDUR as durreplanact
, act.QTACTDUR as durrealorigact
, case when (act.QTACTDUR = 0 or act.QTACTDUR is null) then act.QTREPLDUR else act.QTACTDUR end as durrealact
, case when (act.DTPLANST >= getdate() and act.DTPLANEND >= getdate()) then 0
       when (act.DTPLANST < getdate() and act.DTPLANEND < getdate()) then act.QTPLANDUR
       else coalesce((SELECT (DATEDIFF(dd,act.DTPLANST, getdate())+1)
        -(DATEDIFF(wk,act.DTPLANST, getdate())*2)
        -(CASE WHEN DATENAME(dw, act.DTPLANST) = 'Sunday' THEN 1
          ELSE 0 END)
        -(CASE WHEN DATENAME(dw, getdate()) = 'Saturday' THEN 1
          ELSE 0 END)
        - (select count(1)
            from gncalendar cal
            inner join GNCALEXCEPTION cale on cale.cdcalendar = cal.cdcalendar
            where cal.idcalendar = 'TI_DU'
            and dtday between act.DTPLANST and getdate())), 0) end duraplan
, case when (act.DTREPLST >= getdate() and act.DTREPLEND >= getdate()) then 0
       when (act.DTREPLST < getdate() and act.DTREPLEND < getdate()) then act.QTREPLDUR
       else coalesce((SELECT (DATEDIFF(dd,act.DTREPLST, getdate())+1)
        -(DATEDIFF(wk,act.DTREPLST, getdate())*2)
        -(CASE WHEN DATENAME(dw, act.DTREPLST) = 'Sunday' THEN 1
          ELSE 0 END)
        -(CASE WHEN DATENAME(dw, getdate()) = 'Saturday' THEN 1
          ELSE 0 END)
        - (select count(1)
            from gncalendar cal
            inner join GNCALEXCEPTION cale on cale.cdcalendar = cal.cdcalendar
            where cal.idcalendar = 'TI_DU'
            and dtday between act.DTREPLST and getdate())), 0) end durareplan
, case when (act.DTACTST >= getdate() and act.DTACTEND >= getdate()) then 0
       when (act.DTACTST < getdate() and act.DTACTEND < getdate()) then act.QTACTDUR
       else (((act.QTACTPERC * case when (act.QTACTDUR = 0 or act.QTACTDUR is null) then act.QTREPLDUR else act.QTACTDUR end) / (
case when (coalesce((SELECT (DATEDIFF(dd,act.DTACTST, getdate())+1)
        -(DATEDIFF(wk,act.DTACTST, getdate())*2)
        -(CASE WHEN DATENAME(dw, act.DTACTST) = 'Sunday' THEN 1
          ELSE 0 END)
        -(CASE WHEN DATENAME(dw, getdate()) = 'Saturday' THEN 1
          ELSE 0 END)
        - (select count(1)
            from gncalendar cal
            inner join GNCALEXCEPTION cale on cale.cdcalendar = cal.cdcalendar
            where cal.idcalendar = 'TI_DU'
            and dtday between act.DTACTST and getdate())), 1) * 100) = 0 then 1 else
    coalesce((SELECT (DATEDIFF(dd,act.DTACTST, getdate())+1)
        -(DATEDIFF(wk,act.DTACTST, getdate())*2)
        -(CASE WHEN DATENAME(dw, act.DTACTST) = 'Sunday' THEN 1
          ELSE 0 END)
        -(CASE WHEN DATENAME(dw, getdate()) = 'Saturday' THEN 1
          ELSE 0 END)
        - (select count(1)
            from gncalendar cal
            inner join GNCALEXCEPTION cale on cale.cdcalendar = cal.cdcalendar
            where cal.idcalendar = 'TI_DU'
            and dtday between act.DTACTST and getdate())), 1) * 100
	   end
	   )) *
    (coalesce((SELECT (DATEDIFF(dd,act.DTACTST, getdate())+1)
        -(DATEDIFF(wk,act.DTACTST, getdate())*2)
        -(CASE WHEN DATENAME(dw, act.DTACTST) = 'Sunday' THEN 1
          ELSE 0 END)
        -(CASE WHEN DATENAME(dw, getdate()) = 'Saturday' THEN 1
          ELSE 0 END)
        - (select count(1)
            from gncalendar cal
            inner join GNCALEXCEPTION cale on cale.cdcalendar = cal.cdcalendar
            where cal.idcalendar = 'TI_DU'
            and dtday between act.DTACTST and getdate())), 0) / case when (act.QTACTDUR = 0 or act.QTACTDUR is null) then act.QTREPLDUR else act.QTACTDUR end) *
        case when (act.QTACTDUR = 0 or act.QTACTDUR is null) then act.QTREPLDUR else act.QTACTDUR end) end as durareal
from PRTASK P
inner join prtasktype pty on pty.cdtasktype = p.cdtasktype
inner join prtask prog on prog.nmidtask = p.nmidtask and prog.fgtasktype = 5 and prog.cdtasktype = 4
inner join prtask progr on progr.cdtask = prog.CDBASETASK
inner join prtask act on act.cdbasetask = p.cdtask and act.NMIDTASK <> P.NMIDTASK and not exists (select 1 from prtask acto where acto.CDTASKOWNER = act.cdtask)
where p.cdtasktype = 4 and P.FGTASKTYPE = 1 and P.NRTASKINDEX = 0 and prog.cdtask <> prog.cdbasetask and p.FGPHASE between 2 and 5 and progr.FGPHASE between 2 and 5
and case when (act.QTACTDUR = 0 or act.QTACTDUR is null) then act.QTREPLDUR else act.QTACTDUR end <> 0
and (progr.NMIDTASK like '%'+ right(cast(datepart(yy, getdate()) as varchar), 2) +'%' or
	 progr.NMIDTASK like '%'+ right(cast(datepart(yy, dateadd(year,-1,getdate())) as varchar), 2) +'%')
) _sub
group by idprojeto) kpi on kpi.idprojeto = P.NMIDTASK
where p.cdtasktype = 4 and P.FGTASKTYPE = 1 and p.FGPHASE between 2 and 5 and progr.FGPHASE between 2 and 5
