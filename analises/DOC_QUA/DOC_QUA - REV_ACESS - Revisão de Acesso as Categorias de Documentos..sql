select quem, categoria, nmcat, permissoes, codeq, tpacesso, tppermissao
, usr1.nmuser, usr1.idlogin, usr1.fguserenabled, dep.nmdepartment, pos.nmposition
from (select doc.FGACCESSTYPE as tpacesso
	, case doc.FGPERMISSION when 1 then 'Acesso concedido' when 2 then 'Acesso negado' end as tppermissao
	, case FGACCESSTYPE
              when 1 then case when doc.cdteam is null then 'Outros' else	(select eq.IDTEAM + ' - ' + eq.NMTEAM from adteam eq where eq.cdteam = doc.cdteam) end
              when 2 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment)
              when 3 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment) +' | '+
                  (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
              when 4 then (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
              when 5 then (select usr.idlogin +' - '+ usr.nmuser from aduser usr where usr.cduser = doc.cduser)
              when 6 then 'Todos'
	end as Quem, doc.cdteam as codeq
, cat.idcategory as categoria, cat.nmcategory as nmcat
, cat.idcategory, doc.CDACCESSROLE
, cast ((select substring(__sub.__permissoes, 2, 4000) as [text()] from (
        select case dcc.FGACCESSADD when 1 then '|Incluir' else '' end
        + case dcc.FGACCESSEDIT when 1 then '|Alterar' else '' end
        + case dcc.FGACCESSDELETE when 1 then '|Excluir' else '' end
        + case dcc.FGACCESSKNOW when 1 then '|Conhecimento' else '' end
        + case dcc.FGACCESSTRAIN when 1 then '|Treinamento' else '' end
        + case dcc.FGACCESSVIEW when 1 then '|Visualizar' else '' end
        + case dcc.FGACCESSPRINT when 1 then '|Imprimir' else '' end
        + case dcc.FGACCESSPHYSFILE when 1 then '|Arquivar' else '' end
        + case dcc.FGACCESSREVISION when 1 then '|Revisar' else '' end
        + case dcc.FGACCESSCOPY when 1 then '|Distribuir cópia' else '' end
        + case dcc.FGACCESSREGTRAIN when 1 then '|Registrar treinamento'  else '' end
        + case dcc.FGACCESSCANCEL when 1 then '|Cancelar' else '' end
        + case dcc.FGACCESSSAVE when 1 then '|Salvar localmente' else '' end
        + case dcc.FGACCESSSIGN when 1 then '|Assinatura' else '' end
        + case dcc.FGACCESSNOTIFY when 1 then '|Notificação' else '' end
        + case dcc.FGACCESSEDITKNOW when 1 then '|Avaliar aplicabilidade' else '' end
        + case dcc.FGACCESSADDCOMMENT when 1 then '|Incluir comentário' else '' end as __permissoes
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

