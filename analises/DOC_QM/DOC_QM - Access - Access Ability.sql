select quem, categoria, nmcat, permissoes, codeq, tpacesso, tppermissao
, usr1.nmuser, dep.nmdepartment, pos.nmposition
, case usr1.fguserenabled when 1 then 'Active' when 2 then 'Inactive' end as status
from (select doc.FGACCESSTYPE as tpacesso
	, case doc.FGPERMISSION when 1 then 'Access granted' when 2 then 'access denied' end as tppermissao
	, case FGACCESSTYPE
              when 1 then case when doc.cdteam is null then 'Other' else	(select eq.IDTEAM + ' - ' + eq.NMTEAM from adteam eq where eq.cdteam = doc.cdteam) end
              when 2 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment)
              when 3 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment) +' | '+
                  (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
              when 4 then (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
              when 5 then (select usr.idlogin +' - '+ usr.nmuser from aduser usr where usr.cduser = doc.cduser)
              when 6 then 'All'
	end as Quem, doc.cdteam as codeq
, cat.idcategory as categoria, cat.nmcategory as nmcat
, cat.idcategory, doc.CDACCESSROLE
, cast ((select substring(__sub.__permissoes, 2, 4000) as [text()] from (
        select case dcc.FGACCESSADD when 1 then '|Add' else '' end
        + case dcc.FGACCESSEDIT when 1 then '|Edit' else '' end
        + case dcc.FGACCESSDELETE when 1 then '|Delete' else '' end
        + case dcc.FGACCESSKNOW when 1 then '|Acknowledgment' else '' end
        + case dcc.FGACCESSTRAIN when 1 then '|Training' else '' end
        + case dcc.FGACCESSVIEW when 1 then '|View' else '' end
        + case dcc.FGACCESSPRINT when 1 then '|Print' else '' end
        + case dcc.FGACCESSPHYSFILE when 1 then '|Archive' else '' end
        + case dcc.FGACCESSREVISION when 1 then '|Revise' else '' end
        + case dcc.FGACCESSCOPY when 1 then '|Distribute copy' else '' end
        + case dcc.FGACCESSREGTRAIN when 1 then '|Create training'  else '' end
        + case dcc.FGACCESSCANCEL when 1 then '|Cancel' else '' end
        + case dcc.FGACCESSSAVE when 1 then '|Salve locally' else '' end
        + case dcc.FGACCESSSIGN when 1 then '|Sign' else '' end
        + case dcc.FGACCESSNOTIFY when 1 then '|Notification' else '' end
        + case dcc.FGACCESSEDITKNOW when 1 then '|Evaluate applicability' else '' end
        + case dcc.FGACCESSADDCOMMENT when 1 then '|Add comments' else '' end as __permissoes
from DCCATEGORYDOCROLE dcc
where dcc.CDACCESSROLE = doc.CDACCESSROLE) __sub
for XML path('')) as varchar(4000)) as permissoes
from DCCATEGORYDOCROLE doc
inner join dccategory cat on cat.CDCATEGORY = doc.CDCATEGORY and cat.fgenabled = 1
where 1 = 1
) sub
inner join adteammember equ on equ.cdteam = sub.codeq
inner join aduser usr1 on equ.cduser = usr1.cduser
inner join aduserdeptpos rel on rel.cduser = usr1.cduser and rel.fgdefaultdeptpos = 1
inner join addepartment dep on dep.cddepartment = rel.cddepartment
inner join adposition pos on pos.cdposition = rel.cdposition
where  (codeq <> 00 or codeq is null) 
