select form.itsm001 as [Identificador], cat.itsm003 as [Categoria {en-us}], cat.itsm002 as [Categoria {pt-br}], subc.itsm004 as [SubCategoria {en-us}], subc.itsm003 as [SubCategoria {pt-br}], agrup.itsm001e as [Grouper {en-us}], agrup.itsm001p as [Agrupador {pt-br}], form.itsm002e as [Object {en-us}], form.itsm002p as [Objeto {pt-br}], form.itsm003e as [Service {en-us}], form.itsm003p as [Serviço {pt-br}], form.itsm004e as [Complement {en-us}], form.itsm004p as [Complemento {pt-br}], form.itsm005e as [Descrição {en-us}], form.itsm005p as [Descrição {pt-br}], form.itsm006 as [SLA], form.itsm035 as [Prieiro atendimento], form.itsm007 as [Tipo], form.itsm011e as [Comentários - {en-us}], form.itsm011p as [Comnetários {pt-br}], form.itsm023 as [Atendimento Corporativo], form.itsm021 as [Grupo solucionador], form.itsm012 as [Horário de suporte], form.itsm022 as [Esforço], form.itsm033 as [Quem Solicita - Ninguém], form.itsm008 as [Quem Solicita - Todos], form.itsm009 as [Quem solicita - TI], form.itsm010 as [Quem solicita - DHO], form.itsm024 as [Quem solicita - VSC], form.itsm025 as [Quem solicita - Servicedesk], form.itsm026 as [Quem solicita - Governança], form.itsm034 as [Quem solicita - TEMP], form.itsm028 as [Quem solicita - GQ], form.itsm032 as [Quem solicita - Key user], form.itsm013 as [Aprovação - Líder], form.itsm014 as [Aprovação - Gerente], form.itsm015 as [Aprovação - Diretor], form.itsm016 as [Aprovação - Dono], form.itsm017 as [Aprovação - Gerente TI], form.itsm018 as [Aprovação - Adicional], form.itsm019 as [Aprovação - Adicional (login)], form.itsm020 as [Aprovação - Adicional (nome)], form.itsm029 as [Aprovação - Coord Grupo Soluc.], form.itsm027 as [Automatizado], form.itsm030 as [Automatizado - complemento], form.itsm031 as [Automatizado - Preparação], form.oidrevisionform, form.oid as [oidentityreg], ((select OIDENTITY from EFFORM where oid = (SELECT oidform FROM EFREVISIONFORM WHERE idform = 'itsm001' AND FGCURRENT=1))) as [oidentity] from DYNitsm001 form inner join DYNitsm002 cat on form.OIDABCP4PNGD3QW8LP = cat.oid inner join DYNitsm003 subc on form.OIDABC33MU921YCVUK = subc.oid inner join DYNitsm019 agrup on form.OIDABC868DY7UV2HFM = agrup.oid
