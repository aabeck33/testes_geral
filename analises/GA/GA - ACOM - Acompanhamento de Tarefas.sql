select wf.idprocess, form.sol014, form.sol006 as Acesso, wf.dtstart + wf.tmstart as dtstart, wf.dtfinish + wf.tmfinish as dtfinish
, CASE wf.fgstatus WHEN 1 THEN 'Em andamento' WHEN 2 THEN 'Suspenso' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Encerrado' WHEN 5 THEN 'Bloqueado para edição' END AS status
, (SELECT WFA.NMUSER FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.idstruct = 'Atividade1981103642935' and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as executor
, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
   WHERE  str.idstruct = 'Atividade1981103642935' and str.idprocess=wf.idobject) as habilitada
, (SELECT str.DTEXECUTION + str.TMEXECUTION FROM WFSTRUCT STR
   WHERE str.idstruct = 'Atividade1981103642935' and str.idprocess=wf.idobject) as excutada
, datediff(hh, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
                WHERE  str.idstruct = 'Atividade1981103642935' and str.idprocess=wf.idobject)
   , (SELECT str.DTEXECUTION + str.TMEXECUTION FROM WFSTRUCT STR
      WHERE str.idstruct = 'Atividade1981103642935' and str.idprocess=wf.idobject)) as tempo
, (SELECT str.nmstruct FROM WFSTRUCT STR
   WHERE str.fgstatus = 2 and str.idprocess=wf.idobject) as atvatual
, (SELECT str.DTENABLED + str.TMENABLED FROM WFSTRUCT STR
   WHERE str.fgstatus = 2 and str.idprocess = wf.idobject) as atvatual_habilitada
, (SELECT str.DTEXECUTION + str.TMEXECUTION FROM WFSTRUCT STR
   WHERE str.fgstatus = 2 and str.idprocess=wf.idobject) as atvatual_excutada
, (SELECT case wfa.FGEXECUTORTYPE
               when 1 then wfa.nmrole
               when 3 then wfa.nmuser
               when 4 then wfa.nmuser
               else 'indefinido'
          end
   FROM WFSTRUCT STR, WFACTIVITY WFA
   WHERE str.fgstatus = 2 and str.idprocess=wf.idobject and str.idobject = wfa.idobject) as atvatual_executor
from DYNsolws form
inner join gnassocformreg gnf on (gnf.oidentityreg = form.oid)
inner join wfprocess wf on (wf.cdassocreg = gnf.cdassoc)
where wf.cdprocessmodel = 5283  and form.sol014 like '%ua'
