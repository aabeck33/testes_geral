select usr.nmuser, usr.idlogin
from aduser usr
inner join aduseraccgroup acg on acg.cduser = usr.cduser
where acg.cdgroup = (select cdgroup from adaccessgroup where idgroup = 'DOC_ARQREV')
