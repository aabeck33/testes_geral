Select wf.idprocess, wf.NMUSERSTART as iniciador, dep.nmdepartment as areainiciador, gnrev.NMREVISIONSTATUS as status, wf.nmprocess, wf.DTSTART as dtabertura
, case wf.fgstatus when 1 then 'Em andamento' when 2 then 'Suspenso' when 3 then 'Cancelado' when 4 then 'Encerrado' when 5 then 'Bloqueado para edição' end as statusproc
, case 
            when wf.dtfinish is null then (select max(his.DTHISTORY+his.TMHISTORY)  from wfhistory his 
            where  HIS.FGTYPE = 3 and his.idprocess = wf.idobject and not exists  (select  his1.fgtype from wfhistory his1 
                where  HIS1.FGTYPE = 5  and his1.idprocess = his.idprocess  and his1.DTHISTORY+his1.TMHISTORY  > his.DTHISTORY+his.TMHISTORY)) else wf.dtfinish 
            end as dtfechamento

, (select substring((
select ' | '+ substring((select nmlabel from EMATTRMODEL where oidentity = (select oid from EMENTITYMODEL where idname = 'tds015') and idname=coluna),10,250) as [text()]
from (select * from dyntds015 where OID = form.oid) s
unpivot (valor for coluna in (tds027, tds028, tds029, tds030, tds031, tds032, tds033, tds034, tds035, tds036, tds037, tds038, tds039, tds040, tds041, tds042, tds043, tds044, tds045, tds046, tds047, tds048, tds049, tds050, tds051, tds052, tds053, tds054, tds055, tds056, tds057, tds058, tds059, tds060, tds061, tds062, tds063, tds064, tds065, tds066, tds104)) as tt
where valor = 1 FOR XML PATH('')), 4, 1000)) as listamudanca
, coalesce((select substring((select ' | '+ tbs001 as [text()] from DYNtbs040 where OIDABCTTKABCKFM = form.oid FOR XML PATH('')), 4, 1000)), 'NA') as listaclientes
, coalesce((select substring((select ' | # '+ coalesce(tbs002,' ') +' - '+ coalesce(tbs001,' ') +' ('+ coalesce(tbs003,' ') +' | '+ coalesce(tbs004,' ') +' | '+ coalesce(format(tbs005,'dd/MM/yyyy'),' ') +' | '+ coalesce(tbs006,' ') +')' as [text()] from DYNtbs024 where OIDABCIQeABC45y = form.oid FOR XML PATH('')), 4, 40000)), 'NA') as listaprodlote
, (row_number() over (PARTITION BY wf.idprocess,str.nmstruct order by wf.idprocess,str.nmstruct,his.dthistory + his.tmhistory)) as ciclo
, str.nmstruct as atividade
, (select top 1 his1.dthistory + his1.tmhistory
   from wfhistory his1
   where his1.idprocess = wf.idobject and HIS1.FGTYPE = 6 and his1.IDSTRUCT = his.IDSTRUCT
         and his1.dthistory + his1.tmhistory < his.dthistory + his.tmhistory
   order by his1.dthistory + his1.tmhistory desc
) as atvHabilitada
, his.dthistory + his.tmhistory as atvExecutada
, his.NMUSER as atvExecutor
, his.nmaction as atvAcao
, 1 as Quantidade
from DYNtds015 form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
INNER JOIN INOCCURRENCE INC ON (wf.IDOBJECT = INC.IDWORKFLOW)
inner join aduser usr on usr.cduser = wf.cdUSERSTART
inner join aduserdeptpos rel on rel.cduser = usr.cduser and rel.FGDEFAULTDEPTPOS = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
LEFT OUTER JOIN GNREVISIONSTATUS GNrev ON (INC.CDSTATUS = GNrev.CDREVISIONSTATUS)
inner join WFHISTORY HIS on his.idprocess = wf.idobject and HIS.FGTYPE = 9
inner JOIN WFSTRUCT STR ON HIS.IDSTRUCT=STR.IDOBJECT and (str.idstruct in ('Atividade141029141729547', 'Atividade141111113134390', 'Decisão14102914531751', 'Decisão14102914536874', 'Decisão141111113212628', 'Atividade14102914543984'))
LEFT OUTER JOIN WFACTIVITY WFA ON STR.IDOBJECT = WFA.IDOBJECT
where cdprocessmodel=3234
