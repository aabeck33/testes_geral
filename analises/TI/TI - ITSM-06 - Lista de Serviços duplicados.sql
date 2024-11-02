select form1.itsm001 as item1, form2.itsm001 as item2
, form1.itsm002p, form1.itsm003p, form1.itsm004p
, form1.itsm002e, form1.itsm003e, form1.itsm004e
from dynitsm001 form1
inner join dynitsm001 form2 on ((form2.itsm002p = form1.itsm002p and form2.itsm003p = form1.itsm003p and form2.itsm004p = form1.itsm004p) or
((form2.itsm002e = form1.itsm002e and form2.itsm003e = form1.itsm003e and form2.itsm004e = form1.itsm004e)))
and form1.oid <> form2.oid and substring(form2.itsm001, 9, 7) > substring(form1.itsm001, 9, 7)
