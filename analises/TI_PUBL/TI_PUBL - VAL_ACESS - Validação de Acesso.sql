select quem, categoria, nmcat,  usr.idlogin, usr.nmuser, permissoes
from (select doc.FGACCESSTYPE,
case FGACCESSTYPE   when 1 then eq.IDTEAM + ' - ' + eq.NMTEAM
                    when 2 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment)
                    when 3 then (select dep.iddepartment +' - '+ dep.nmdepartment from addepartment dep where dep.cddepartment = doc.cddepartment) +' | '+
                        (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
                    when 4 then (select pos.idposition +' - '+ pos.nmposition from adposition pos where pos.cdposition = doc.cdposition)
                    when 5 then (select usr.idlogin +' - '+ usr.nmuser from aduser usr where usr.cduser = doc.cduser)
                    when 6 then 'Todos'
end as Quem
, eq.cdteam as codeq
, cat.idcategory as categoria, cat.nmcategory as nmcat
, 'Tem acesso '+ case doc.FGPERMISSION when 1 then 'concedido' when 2 then 'negado' end
  +' na categoria: '+ cat.idcategory +' - '+ cat.NMCATEGORY as Oque, 'Documentos' as Modulo
,eq.idteam, cat.idcategory, doc.CDACCESSROLE
,cast ((select substring(__sub.__permissoes, 2, 4000) as [text()] from (select case dcc.FGACCESSADD when 1 then '|Incluir' else '' end
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
left join ADTEAM eq on eq.cdteam = doc.CDTEAM
left join addepartment dep on dep.cddepartment = doc.CDdepartment
inner join dccategory cat on cat.CDCATEGORY = doc.CDCATEGORY
where (doc.CDTEAM is not null and doc.CDDEPARTMENT is null) or (doc.CDTEAM is null and doc.CDDEPARTMENT is not null)) sub
inner join adteammember equ on equ.cdteam = sub.codeq
inner join aduser usr on usr.cduser = equ.cduser
where  quem <> 'TI_ADMINISTRADOR - EQUIPE TI ADMINISTRADOR SE SUITE'

