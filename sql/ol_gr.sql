/* Formatted on 19/11/2014 17:57:40 (QP5 v5.227.12220.39724) */
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
ORDER BY gr