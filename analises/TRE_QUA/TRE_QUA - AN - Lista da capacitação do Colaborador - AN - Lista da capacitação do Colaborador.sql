select revc.cdrevision, usr.nmuser, usr.iduser, pos.nmposition, co.idcourse, revc.iddocument
, (select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1)) as areapadrao
, case relc.fgreq when 1 then 'Requerido' when 2 then 'Desejável' end as Requerido
, (select max(tr1.DTREALFINISH)
   from TRTRAINING tr1
   inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
   inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
  ) as dttreinamento
, coalesce((select top 1 CASE WHEN TU2.FGRESULT = 1 THEN 'Aprovado'
                              WHEN TU2.FGRESULT = 2 THEN 'Reprovado'
                         END tt
            from TRTRAINING tr2
            inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr.cduser
			inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
            where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
            from TRTRAINING tr1
            inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
			inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
          )), 'Não avaliado') as Condicao
, (select top 1 tr2.idtrain tt
   from TRTRAINING tr2
   inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr.cduser
   inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
   where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
   from TRTRAINING tr1
   inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
   inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
 )) as treinamento
, case when ((select dtaprova from (select rev1.iddocument, gnrev1.fgstatus, rev1.cdrevision, rev1.fgcurrent, stag1.FGSTAGE as fase
              , min(stag1.NRCYCLE) as ciclo, min(stag1.DTAPPROVAL) as dtaprova, gnrev1.idrevision
              from dcdocrevision rev1
              inner join dccategory cat1 on cat1.cdcategory = rev1.cdcategory
              inner join gnrevision gnrev1 on gnrev1.cdrevision = rev1.cdrevision
              inner join dcdocument doc1 on rev1.cddocument = doc1.cddocument
              INNER JOIN GNREVISIONSTAGMEM stag1 ON gnrev1.CDREVISION = stag1.CDREVISION
              where doc1.fgstatus < 4 and stag1.FGSTAGE = 3 and stag1.DTAPPROVAL is not null
              and rev1.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument=revc.cddocument)
              group by rev1.cdrevision, rev1.iddocument, rev1.fgcurrent, gnrev1.fgstatus, gnrev1.idrevision, stag1.FGSTAGE) __sub1)
              <=
              (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument)
             or
             (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument) >= gnrevc.DTREVISION)
             and
              (coalesce((select top 1 CASE WHEN TU2.FGRESULT = 1 THEN 'Aprovado'
                                           WHEN TU2.FGRESULT = 2 THEN 'Reprovado'
                                      END sit
                         from TRTRAINING tr2
                         inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr.cduser
						 inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
                         where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
                         from TRTRAINING tr1
                         inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr.cduser
						 inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
                         ) order by tr2.cdtrain desc), 'Não avaliado') = 'Aprovado')
       then 'Ok'
       else 'Pendente'
end Situacao
, gnrevc.DTREVISION
, (select dtaprova from (select rev1.iddocument, gnrev1.fgstatus, rev1.cdrevision, rev1.fgcurrent, stag1.FGSTAGE as fase
   , min(stag1.NRCYCLE) as ciclo, min(stag1.DTAPPROVAL) as dtaprova, gnrev1.idrevision
            from dcdocrevision rev1
            inner join dccategory cat1 on cat1.cdcategory = rev1.cdcategory
            inner join gnrevision gnrev1 on gnrev1.cdrevision = rev1.cdrevision
            inner join dcdocument doc1 on rev1.cddocument = doc1.cddocument
            INNER JOIN GNREVISIONSTAGMEM stag1 ON gnrev1.CDREVISION = stag1.CDREVISION
            where doc1.fgstatus < 4 and stag1.FGSTAGE = 3 and rev1.fgcurrent = 1
            and rev1.cddocument = revc.cddocument and stag1.DTAPPROVAL is not null
            group by rev1.cdrevision, rev1.iddocument, rev1.fgcurrent, gnrev1.fgstatus, gnrev1.idrevision, stag1.FGSTAGE) __sub1) as data_primeira_aprovacao
, (select count(posp.nmposition)
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and rel.FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos on pos.cdposition = rel.cdposition
left join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
inner join aduserdeptpos relp on relp.cduser = usr0.cduser and relp.FGDEFAULTDEPTPOS = 1
inner join addepartment depp on depp.cddepartment = relp.cddepartment
inner join adposition posp on posp.cdposition = relp.cdposition
where usr0.cduser = usr.cduser) as totalusr
, (select count(posp.nmposition)
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and rel.FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos0 on pos0.cdposition = rel.cdposition
left join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
inner join aduserdeptpos relp on relp.cduser = usr0.cduser and relp.FGDEFAULTDEPTPOS = 1
inner join addepartment depp on depp.cddepartment = relp.cddepartment
inner join adposition posp on posp.cdposition = relp.cdposition
where pos0.cdposition=pos.cdposition) as totalrole
, (select count(posp.nmposition)
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and rel.FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos0 on pos0.cdposition = rel.cdposition
left join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
inner join aduserdeptpos relp on relp.cduser = usr0.cduser and relp.FGDEFAULTDEPTPOS = 1
inner join addepartment depp on depp.cddepartment = relp.cddepartment
inner join adposition posp on posp.cdposition = relp.cdposition
where (select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr0.cduser and FGDEFAULTDEPTPOS = 1))
= (select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1))) as totalareapad
, (select count(__subapro.situacao) from (select case when ((select dtaprova from (select rev1.iddocument, gnrev1.fgstatus, rev1.cdrevision, rev1.fgcurrent, stag1.FGSTAGE as fase
              , min(stag1.NRCYCLE) as ciclo, min(stag1.DTAPPROVAL) as dtaprova, gnrev1.idrevision
              from dcdocrevision rev1
              inner join dccategory cat1 on cat1.cdcategory = rev1.cdcategory
              inner join gnrevision gnrev1 on gnrev1.cdrevision = rev1.cdrevision
              inner join dcdocument doc1 on rev1.cddocument = doc1.cddocument
              INNER JOIN GNREVISIONSTAGMEM stag1 ON gnrev1.CDREVISION = stag1.CDREVISION
              where doc1.fgstatus < 4 and stag1.FGSTAGE = 3 and stag1.DTAPPROVAL is not null
              and rev1.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument=revc.cddocument)
              group by rev1.cdrevision, rev1.iddocument, rev1.fgcurrent, gnrev1.fgstatus, gnrev1.idrevision, stag1.FGSTAGE) __sub1)
              <=
              (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument)
             or
             (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument) >= gnrevc.DTREVISION)
             and
              (coalesce((select top 1 CASE WHEN TU2.FGRESULT = 1 THEN 'Aprovado'
                                      WHEN TU2.FGRESULT = 2 THEN 'Reprovado'
                                 END sit
                         from TRTRAINING tr2
                         inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
                         where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
                         from TRTRAINING tr1
                         inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
                         ) order by tr2.cdtrain desc), 'Não avaliado') = 'Aprovado')
       then 'Ok'
       else 'Pendente'
end Situacao
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos on pos.cdposition = rel.cdposition
inner join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocument doc on doc.cddocument = docc.cddocument
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
where usr0.cduser = usr.cduser) __subapro where __subapro.situacao = 'Ok') as qtd_aprousr
, (select count(__subapro.situacao) from (select case when ((select dtaprova from (select rev1.iddocument, gnrev1.fgstatus, rev1.cdrevision, rev1.fgcurrent, stag1.FGSTAGE as fase
              , min(stag1.NRCYCLE) as ciclo, min(stag1.DTAPPROVAL) as dtaprova, gnrev1.idrevision
              from dcdocrevision rev1
              inner join dccategory cat1 on cat1.cdcategory = rev1.cdcategory
              inner join gnrevision gnrev1 on gnrev1.cdrevision = rev1.cdrevision
              inner join dcdocument doc1 on rev1.cddocument = doc1.cddocument
              INNER JOIN GNREVISIONSTAGMEM stag1 ON gnrev1.CDREVISION = stag1.CDREVISION
              where doc1.fgstatus < 4 and stag1.FGSTAGE = 3 and stag1.DTAPPROVAL is not null
              and rev1.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument=revc.cddocument)
              group by rev1.cdrevision, rev1.iddocument, rev1.fgcurrent, gnrev1.fgstatus, gnrev1.idrevision, stag1.FGSTAGE) __sub1)
              <=
              (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument)
             or
             (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument) >= gnrevc.DTREVISION)
             and
              (coalesce((select top 1 CASE WHEN TU2.FGRESULT = 1 THEN 'Aprovado'
                                      WHEN TU2.FGRESULT = 2 THEN 'Reprovado'
                                 END sit
                         from TRTRAINING tr2
                         inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
                         where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
                         from TRTRAINING tr1
                         inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
                         ) order by tr2.cdtrain desc), 'Não avaliado') = 'Aprovado')
       then 'Ok'
       else 'Pendente'
end Situacao
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos0 on pos0.cdposition = rel.cdposition
inner join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocument doc on doc.cddocument = docc.cddocument
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
where pos0.cdposition=pos.cdposition) __subapro where __subapro.situacao = 'Ok') as qtd_aprorole
, (select count(__subapro.situacao) from (select case when ((select dtaprova from (select rev1.iddocument, gnrev1.fgstatus, rev1.cdrevision, rev1.fgcurrent, stag1.FGSTAGE as fase
              , min(stag1.NRCYCLE) as ciclo, min(stag1.DTAPPROVAL) as dtaprova, gnrev1.idrevision
              from dcdocrevision rev1
              inner join dccategory cat1 on cat1.cdcategory = rev1.cdcategory
              inner join gnrevision gnrev1 on gnrev1.cdrevision = rev1.cdrevision
              inner join dcdocument doc1 on rev1.cddocument = doc1.cddocument
              INNER JOIN GNREVISIONSTAGMEM stag1 ON gnrev1.CDREVISION = stag1.CDREVISION
              where doc1.fgstatus < 4 and stag1.FGSTAGE = 3 and stag1.DTAPPROVAL is not null
              and rev1.cdrevision in (select max(cdrevision) from dcdocrevision where cddocument=revc.cddocument)
              group by rev1.cdrevision, rev1.iddocument, rev1.fgcurrent, gnrev1.fgstatus, gnrev1.idrevision, stag1.FGSTAGE) __sub1)
              <=
              (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument)
             or
             (select max(tr1.DTREALFINISH)
              from TRTRAINING tr1
              inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
			  inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument) >= gnrevc.DTREVISION)
             and
              (coalesce((select top 1 CASE WHEN TU2.FGRESULT = 1 THEN 'Aprovado'
                                      WHEN TU2.FGRESULT = 2 THEN 'Reprovado'
                                 END sit
                         from TRTRAINING tr2
                         inner join TRTRAINUSER tu2 on tu2.cdtrain = tr2.cdtrain and tu2.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc2 on docc2.cdcourse = tr2.cdcourse and docc2.cddocument = revc.cddocument
                         where tr2.DTREALFINISH = (select max(tr1.DTREALFINISH)
                         from TRTRAINING tr1
                         inner join TRTRAINUSER tu1 on tu1.cdtrain = tr1.cdtrain and tu1.cduser = usr0.cduser
						 inner join DCDOCCOURSE docc1 on docc1.cdcourse = tr1.cdcourse and docc1.cddocument = revc.cddocument
                         ) order by tr2.cdtrain desc), 'Não avaliado') = 'Aprovado')
       then 'Ok'
       else 'Pendente'
end Situacao
from aduser usr0
inner join aduserdeptpos rel on rel.cduser = usr0.cduser and FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos0 on pos0.cdposition = rel.cdposition
inner join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocument doc on doc.cddocument = docc.cddocument
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
where (select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr0.cduser and FGDEFAULTDEPTPOS = 1))
= (select nmdepartment from addepartment where cddepartment = (select reldef.cddepartment from aduserdeptpos reldef where reldef.cduser = usr.cduser and FGDEFAULTDEPTPOS = 1))) __subapro where __subapro.situacao = 'Ok') as qtd_aproareapad
, gnrevc.idrevision, 1 as quantidade
from aduser usr
inner join aduserdeptpos rel on rel.cduser = usr.cduser and FGDEFAULTDEPTPOS = 2
inner join addepartment dep on dep.cddepartment = rel.cddepartment and dep.cddepartment in (164)
inner join adposition pos on pos.cdposition = rel.cdposition
left join addeptposition deppos on deppos.cdposition = rel.cdposition and deppos.cddepartment = rel.cddepartment
left join GNCOURSEMAPITEM relc on relc.cdmapping = deppos.cdmapping
left join DCDOCCOURSE docc on docc.cdcourse = relc.cdcourse
left join dcdocrevision revc on revc.cddocument = docc.cddocument and revc.fgcurrent = 1
left join gnrevision gnrevc on gnrevc.cdrevision = revc.cdrevision
left join trcourse co on co.cdcourse = docc.cdcourse
