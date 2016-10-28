/* Formatted on 12/29/2015 10:53:00  (QP5 v5.252.13127.32867) */
  SELECT *
    FROM (SELECT *
            FROM ol_gr
           WHERE dpt_id = :dpt_id
          UNION
              SELECT DISTINCT 0 id,
                              'Руководители' name,
                              SYSDATE lu,
                              LEVEL + 900 gr,
                              :dpt_id dpt_id
                FROM (SELECT *
                        FROM full
                       WHERE full = 1 AND datauvol IS NULL) z
          START WITH slave IS NOT NULL
          CONNECT BY PRIOR master = slave
          UNION
          SELECT DISTINCT 0 id,
                          'Подтверждение расчета' name,
                          SYSDATE lu,
                          1111 gr,
                          :dpt_id dpt_id
            FROM DUAL)
ORDER BY gr NULLS FIRST