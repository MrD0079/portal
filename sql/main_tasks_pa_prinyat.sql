/* Formatted on 09/04/2015 12:54:48 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c, full, ok
    FROM (SELECT full,
                 NVL (
                    (SELECT plan_ok
                       FROM p_activ_plan_monthly m
                      WHERE     TO_DATE (1 || '.' || m.m || '.' || m.y,
                                         'dd.mm.yyyy') =
                                   (SELECT CASE
                                              WHEN TO_CHAR (SYSDATE, 'dd') > 25
                                              THEN
                                                 ADD_MONTHS (
                                                    TRUNC (SYSDATE, 'mm'),
                                                    1)
                                              ELSE
                                                 TRUNC (SYSDATE, 'mm')
                                           END
                                      FROM DUAL)
                            AND m.tn = z1.tn),
                    0)
                    ok
            FROM (SELECT full, slave tn
                    FROM full
                   WHERE dpt_id = :dpt_id AND master = :tn) z1,
                 user_list u
           WHERE u.tn = z1.tn AND NVL (u.is_top, 0) <> 1 AND u.datauvol IS NULL)
GROUP BY full, ok