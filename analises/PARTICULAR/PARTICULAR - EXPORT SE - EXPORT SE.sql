SELECT
    A.FGTYPEANALISYS,
    A.IDANALISYS,
    A.NMANALISYS,
    A.CDANALISYS
FROM
    GNANALISYS A,
    GNTOOLSANALISYS T
WHERE
    T.CDTOOLSANALISYS = A.CDTOOLSANALISYS
    AND T.CDISOSYSTEM = 202
    AND A.CDTOOLSANALISYS = 27020