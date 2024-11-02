SELECT
    usr.nmuser,
    usr.idlogin,
    COALESCE((
            SELECT nmdepartment
            FROM addepartment (NOLOCK)
            WHERE cddepartment = (
                SELECT reldef.cddepartment
                FROM aduserdeptpos reldef (NOLOCK)
                WHERE reldef.cduser = usr.cduser
                AND FGDEFAULTDEPTPOS = 1
            )
    ), 'NA') AS areapadrao,
    CASE
        WHEN CHARINDEX('-', idposition) <> 0 THEN SUBSTRING(idposition, CHARINDEX('-', idposition) + 1, 2)
        ELSE ''
    END AS setor,
    CASE
        WHEN CHARINDEX('-', idposition) <> 0 THEN SUBSTRING(idposition, 1, CHARINDEX('-', idposition) - 1)
        ELSE ''
    END AS unid,
    idposition,
    revc.iddocument,
    gnrevc.idrevision,
    revc.iddocument + '-' + gnrevc.idrevision AS POP,
    CASE
        WHEN (
            COALESCE(
                (SELECT
                    CASE
                        WHEN tu1.fgresult = 1 THEN 'Aprovado'
                        WHEN tu1.fgresult = 2 THEN 'Reprovado'
                    END
                FROM
                    trtraining tr1
                INNER JOIN TRTRAINUSER tu1 ON tu1.cdtrain = tr1.cdtrain AND tu1.cduser = usr.cduser
                LEFT JOIN DCDOCTRAIN trev1 ON trev1.cdtrain = tr1.cdtrain
                WHERE
                    tr1.cdcourse = co.cdcourse
                    AND (
                        (revc.cdrevision IS NOT NULL AND trev1.cdrevision = revc.cdrevision)
                        OR (revc.cdrevision IS NULL AND trev1.cdrevision IS NULL)
                    )
                    AND tr1.fgstatus = 8
                    AND tr1.FGCANCEL <> 1
                    AND tr1.cdtrain = (
                        SELECT MAX(tr2.cdtrain) AS cdtrain
                        FROM TRTRAINING tr2
                        INNER JOIN TRTRAINUSER tu2 ON tu2.cdtrain = tr2.cdtrain AND tu2.cduser = usr.cduser
                        LEFT JOIN DCDOCTRAIN trev2 ON trev2.cdtrain = tr2.cdtrain
                        WHERE
                            tr2.cdcourse = co.cdcourse
                            AND (
                                (revc.cdrevision IS NOT NULL AND trev2.cdrevision = revc.cdrevision)
                                OR (revc.cdrevision IS NULL AND trev2.cdrevision IS NULL)
                            )
                            AND tr2.fgstatus = 8
                            AND tr2.FGCANCEL <> 1
                    )
                ),
                'Não avaliado'
            ) = 'Aprovado'
        ) THEN 'Treinado'
        ELSE
            CASE
                WHEN gnrevc.DTREVISION IS NOT NULL THEN
                    CASE
                        WHEN (GETDATE() - gnrevc.DTREVISION) <= 30 THEN 'Aguardando Treinamento'
                        ELSE 'Pendente'
                    END
                ELSE
                    CASE
                        WHEN (
                            GETDATE() - (
                                SELECT MAX(stag1.dtapproval)
                                FROM dcdocrevision revi
                                INNER JOIN gnrevision gnrevi ON gnrevi.cdrevision = revi.cdrevision
                                INNER JOIN GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                                WHERE
                                    revi.cdrevision = (
                                        SELECT MAX(cdrevision)
                                        FROM dcdocrevision
                                        WHERE cddocument = revc.cddocument
                                    )
                                    AND stag1.fgstage = 3
                                    AND nrcycle = (
                                        SELECT MAX(stag1.nrcycle)
                                        FROM dcdocrevision revi
                                        INNER JOIN gnrevision gnrevi ON gnrevi.cdrevision = revi.cdrevision
                                        INNER JOIN GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                                        WHERE
                                            revi.cdrevision = (
                                                SELECT MAX(cdrevision)
                                                FROM dcdocrevision
                                                WHERE cddocument = revc.cddocument
                                            )
                                            AND stag1.fgstage = 3
                                    )
                            )
                        ) <= 60 THEN 'Aguardando Treinamento – Homologação'
                        ELSE 'Aguardando Treinamento – Homologação (em atraso)'
                    END
            END
    END AS Situacao,
    1 AS quantidade
FROM
    aduser usr
INNER JOIN aduserdeptpos rel0 ON rel0.cduser = usr.cduser AND FGDEFAULTDEPTPOS = 2
INNER JOIN addepartment dep ON dep.cddepartment = rel0.cddepartment AND dep.cddepartment IN (164)
INNER JOIN adposition pos ON pos.cdposition = rel0.cdposition AND pos.fgposenabled = 1 AND (pos.idposition LIKE 'PA0052%')
INNER JOIN addeptposition deppos ON deppos.cdposition = rel0.cdposition AND deppos.cddepartment = rel0.cddepartment
INNER JOIN GNCOURSEMAPITEM relc ON relc.cdmapping = deppos.cdmapping
LEFT JOIN DCDOCCOURSE docc ON docc.cdcourse = relc.cdcourse
LEFT JOIN dcdocument doc ON doc.cddocument = docc.cddocument AND doc.fgstatus <> 4
LEFT JOIN dcdocrevision revc ON revc.cddocument = docc.cddocument AND revc.cdrevision IN (
    SELECT MAX(revo.cdrevision)
    FROM dcdocrevision revo
    WHERE revo.cddocument = revc.cddocument
        AND revo.fgcurrent = 
		CASE
            WHEN (
                (SELECT DISTINCT gnrevi.fgstatus
                FROM dcdocrevision revi
                INNER JOIN gnrevision gnrevi ON gnrevi.cdrevision = revi.cdrevision
                INNER JOIN GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                WHERE
                    revi.cdrevision = (
                        SELECT MAX(cdrevision)
                        FROM dcdocrevision
                        WHERE cddocument = revo.cddocument
                    )
                ) <> 4
                AND (
                    (SELECT DISTINCT gnrevi.fgstatus
                    FROM dcdocrevision revi
                    INNER JOIN gnrevision gnrevi ON gnrevi.cdrevision = revi.cdrevision
                    INNER JOIN GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                    WHERE
                        revi.cdrevision = (
                            SELECT MAX(cdrevision)
                            FROM dcdocrevision
                            WHERE cddocument = revo.cddocument
                        )
                    ) <> 5
                )
            ) THEN 1
            ELSE
                CASE (
                    SELECT doco.fgstatus
                    FROM dcdocument doco
                    WHERE doco.cddocument = revo.cddocument
                )
                    WHEN 1 THEN 1
                    WHEN 2 THEN 1
                    WHEN 4 THEN 1
                    ELSE 2
                END
        END
)
LEFT JOIN gnrevision gnrevc ON gnrevc.cdrevision = revc.CDREVISION
INNER JOIN trcourse co ON co.cdcourse = relc.cdcourse
    AND co.fgenabled = 1
    AND co.cdcoursetype IN (37, 38, 46, 62, 70, 71, 97, 111, 114, 105, 107, 109, 112, 138, 146, 147, 207)
WHERE
    usr.fguserenabled = 1
    AND (
        gnrevc.DTREVISION IS NOT NULL
        OR (
            gnrevc.DTREVISION IS NULL
            AND (
                SELECT MIN(fgstage)
                FROM (
                    SELECT
                        fgstage,
                        nrcycle,
                        dtdeadline,
                        fgapproval,
                        dtapproval
                    FROM
                        GNREVISIONSTAGMEM
                    WHERE
                        cdrevision = revc.cdrevision
                        AND nrcycle = (
                            SELECT MAX(stag1.nrcycle)
                            FROM dcdocrevision revi
                            INNER JOIN gnrevision gnrevi ON gnrevi.cdrevision = revi.cdrevision
                            INNER JOIN GNREVISIONSTAGMEM stag1 ON stag1.CDREVISION = revi.CDREVISION
                            WHERE
                                revi.cdrevision = (
                                    SELECT MAX(cdrevision)
                                    FROM dcdocrevision
                                    WHERE cddocument = revc.cddocument
                                )
                        )
                ) _sub
                WHERE
                    dtdeadline IS NOT NULL
                    AND fgapproval IS NULL
                    AND dtapproval IS NULL
            ) > 3
        )
    )
