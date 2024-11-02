Select
        wf.idprocess,
        wf.NMUSERSTART as iniciador,
        dep.nmdepartment as areainiciador,
        gnrev.NMREVISIONSTATUS as status,
        wf.nmprocess ,
        case wf.fgstatus 
            when 1 then 'Em andamento' 
            when 2 then 'Suspenso' 
            when 3 then 'Cancelado' 
            when 4 then 'Encerrado' 
            when 5 then 'Bloqueado para edição' 
        end as statusproc ,
        wf.dtstart as dtabertura ,
        case 
            when wf.dtfinish is null then (select
                max(his.DTHISTORY+his.TMHISTORY) 
            from
                wfhistory his 
            where
                HIS.FGTYPE = 3 
                and his.idprocess = wf.idobject 
                and not exists  (select
                    his1.fgtype 
                from
                    wfhistory his1 
                where
                    HIS1.FGTYPE = 5 
                    and his1.idprocess = his.idprocess 
                    and his1.DTHISTORY+his1.TMHISTORY  > his.DTHISTORY+his.TMHISTORY)) 
                else wf.dtfinish 
            end as dtfechamento , mud.tbs001 as mudanca , 1 as quantidade 
        from
            DYNtbs015 form 
        inner join
            GNFORMREG reg 
                on reg.OIDENTITYREG = form.OID 
        inner join
            GNFORMREGGROUP grop 
                on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP 
        inner join
            WFPROCESS wf 
                on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP 
        INNER JOIN
            INOCCURRENCE INC 
                ON (
                    wf.IDOBJECT = INC.IDWORKFLOW
                ) 
        inner join
            aduser usr 
                on usr.cduser = wf.cdUSERSTART 
        inner join
            aduserdeptpos rel 
                on rel.cduser = usr.cduser 
                and rel.FGDEFAULTDEPTPOS = 1 
        inner join
            addepartment dep 
                on dep.cddepartment = rel.cddepartment 
        LEFT OUTER JOIN
            GNREVISIONSTATUS GNrev 
                ON (
                    INC.CDSTATUS = GNrev.CDREVISIONSTATUS
                ) 
        inner join
            DYNtbs019 mud 
                on mud.OIDABCJonABCFKa = form.oid 
        where
            cdprocessmodel=1 
        union
        Select
            wf.idprocess,
            wf.NMUSERSTART as iniciador,
            dep.nmdepartment as areainiciador,
            gnrev.NMREVISIONSTATUS as status,
            wf.nmprocess ,
            case wf.fgstatus 
                when 1 then 'Em andamento' 
                when 2 then 'Suspenso' 
                when 3 then 'Cancelado' 
                when 4 then 'Encerrado' 
                when 5 then 'Bloqueado para edição' 
            end as statusproc ,
            wf.dtstart as dtabertura ,
            case 
                when wf.dtfinish is null then (select
                    max(his.DTHISTORY+his.TMHISTORY) 
                from
                    wfhistory his 
                where
                    HIS.FGTYPE = 3 
                    and his.idprocess = wf.idobject 
                    and not exists  (select
                        his1.fgtype 
                    from
                        wfhistory his1 
                    where
                        HIS1.FGTYPE = 5 
                        and his1.idprocess = his.idprocess 
                        and his1.DTHISTORY+his1.TMHISTORY  > his.DTHISTORY+his.TMHISTORY)) 
                    else wf.dtfinish 
                end as dtfechamento , mud.mudanca as mudanca , 1 as quantidade 
            from
                DYNtds015 form 
            inner join
                GNFORMREG reg 
                    on reg.OIDENTITYREG = form.OID 
            inner join
                GNFORMREGGROUP grop 
                    on grop.CDFORMREGGROUP = reg.CDFORMREGGROUP 
            inner join
                WFPROCESS wf 
                    on wf.CDFORMREGGROUP = grop.CDFORMREGGROUP 
            INNER JOIN
                INOCCURRENCE INC 
                    ON (
                        wf.IDOBJECT = INC.IDWORKFLOW
                    ) 
            inner join
                aduser usr 
                    on usr.cduser = wf.cdUSERSTART 
            inner join
                aduserdeptpos rel 
                    on rel.cduser = usr.cduser 
                    and rel.FGDEFAULTDEPTPOS = 1 
            inner join
                addepartment dep 
                    on dep.cddepartment = rel.cddepartment 
            LEFT OUTER JOIN
                GNREVISIONSTATUS GNrev 
                    ON (
                        INC.CDSTATUS = GNrev.CDREVISIONSTATUS
                    ) 
            inner join
                (
                    select
                        oid,
                        substring((select
                            nmlabel 
                        from
                            EMATTRMODEL 
                        where
                            oidentity = (select
                                oid 
                            from
                                EMENTITYMODEL 
                            where
                                idname = 'tds015') 
                            and idname=coluna),10,250) as mudanca 
                    from
                        (select
                            * 
                        from
                            dyntds015) s unpivot (valor for coluna in (tds027,
                        tds028,
                        tds029,
                        tds030,
                        tds031,
                        tds032,
                        tds033,
                        tds034,
                        tds035,
                        tds036,
                        tds037,
                        tds038,
                        tds039,
                        tds040,
                        tds041,
                        tds042,
                        tds043,
                        tds044,
                        tds045,
                        tds046,
                        tds047,
                        tds048,
                        tds049,
                        tds050,
                        tds051,
                        tds052,
                        tds053,
                        tds054,
                        tds055,
                        tds056,
                        tds057,
                        tds058,
                        tds059,
                        tds060,
                        tds061,
                        tds062,
                        tds063,
                        tds064,
                        tds065,
                        tds066,
                        tds104)) as tt 
                    where
                        valor = 1
                    ) mud 
                        on mud.oid = form.OID 
                where
                    cdprocessmodel=1
