/* Formatted on 09/04/2015 12:55:08 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c, full, e
    FROM (SELECT full,
                 CASE
                    WHEN   NVL (
                              (SELECT COUNT (*)
                                 FROM p_activ_plan_daily
                                WHERE     tn = z1.tn
                                      AND TRUNC (data, 'mm') =
                                             (SELECT CASE
                                                        WHEN TO_CHAR (SYSDATE,
                                                                      'dd') >
                                                                25
                                                        THEN
                                                           ADD_MONTHS (
                                                              TRUNC (SYSDATE,
                                                                     'mm'),
                                                              1)
                                                        ELSE
                                                           TRUNC (SYSDATE,
                                                                  'mm')
                                                     END
                                                FROM DUAL)),
                              0)
                         + NVL (
                              (SELECT COUNT (*)
                                 FROM p_activ_plan_weekly w
                                WHERE     TO_DATE (
                                             1 || '.' || w.m || '.' || w.y,
                                             'dd.mm.yyyy') =
                                             (SELECT CASE
                                                        WHEN TO_CHAR (SYSDATE,
                                                                      'dd') >
                                                                25
                                                        THEN
                                                           ADD_MONTHS (
                                                              TRUNC (SYSDATE,
                                                                     'mm'),
                                                              1)
                                                        ELSE
                                                           TRUNC (SYSDATE,
                                                                  'mm')
                                                     END
                                                FROM DUAL)
                                      AND w.tn = z1.tn),
                              0) > 0
                    THEN
                       1
                    ELSE
                       0
                 END
                    e
            FROM (SELECT full, slave tn
                    FROM full
                   WHERE dpt_id = :dpt_id AND master = :tn) z1,
                 user_list u
           WHERE u.tn = z1.tn AND NVL (u.is_top, 0) <> 1 AND u.datauvol IS NULL)
GROUP BY full, e