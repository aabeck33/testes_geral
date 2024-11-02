select CAST(CAST(ROUND(attribm.vlvalue,0) as int) as varchar(50)) as chamado
, cast(coalesce((select substring((select ' | '+ rev.iddocument +'/'+ gnrev.idrevision + case doc.fgstatus when 2 then '' else '*' end as [text()]
                 from dcdocumentattrib attrib
                 inner join gnrevision gnrev on gnrev.cdrevision = attrib.cdrevision
                 inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision
                 inner join dcdocument doc on doc.cddocument = rev.cddocument
                 where attrib.vlvalue = attribm.vlvalue
       FOR XML PATH('')), 4, 4000)), 'NA') as varchar(4000)) as listadoc --listdoc--
, datediff(DD
    , coalesce((select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-DE-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (2))
                , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-DE-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (1)))
    , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
                where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-DE-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (3,4))
    )+1 as approvalTimeDE
, datediff(DD
    , coalesce((select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QO-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (2))
                , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QO-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (1)))
    , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
                where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QO-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (3,4))
    )+1 as approvalTimeQO
, datediff(DD
    , coalesce((select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QR-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (2))
                , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QR-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (1)))
    , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
                where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-QR-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (3,4))
    )+1 as approvalTimeQR
, datediff(DD
    , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
        where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-DE-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (1))
    , (select top 1 max(stag1.dtapproval)
        from GNREVISIONSTAGMEM stag1
                where stag1.CDREVISION = (select max(attrib.cdrevision) from dcdocumentattrib attrib inner join dcdocrevision rev on rev.cdrevision = attrib.cdrevision and rev.iddocument like '%-RP-%' where attrib.CDATTRIBUTE = 235 and attrib.vlvalue = attribm.vlvalue)
            AND stag1.dtdeadline IS NOT NULL and stag1.FGSTAGE in (3,4))
    )+1 as totalTime
, 1 as quantidade
from dcdocumentattrib attribm
where attribm.CDATTRIBUTE = 235 and attribm.vlvalue is not null
group by attribm.vlvalue
