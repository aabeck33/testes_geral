select  dc.idcategory, dc.nmcategory
, (select top 1 iddocument from dcdocrevision where cdcategory=dc.cdcategory) as exemplo
, gn.IDMASK, gn.NMMASK
, substring((select ' + '+ case gnmf.fgtype
when 5 then 'DataHora('+ gnmf.IDFORMAT +')'
when 4 then gnmf.IDFIXEDVALUE
when 3 then 'Seq('+ gnmf.IDFORMAT +')'
when 2 then (select 'att_'+ ada.nmlabel from adattribute ada where ada.cdattribute = gnmf.cdattribute) + '('+ gnmf.IDFORMAT + ')'
when 1 then 'obj_'+ case gnmf.fgfield
			 when 1 then 'Id_Categoria'
			 else 'err_'+ cast(gnmf.fgfield as varchar)
			         end + '('+ gnmf.IDFORMAT + ')'
else 'err_'+ cast(gnmf.fgtype as varchar) +' | '+ cast(gnmf.fgfield as varchar)
end as [text()]
			 from gnmaskfield gnmf where gn.cdmask = gnmf.cdmask order by gnmf.nrsequence for XML path('')), 4, 4000) as campos
from  gnmask gn
inner join dccategory dc on dc.cdmask = gn.cdmask
