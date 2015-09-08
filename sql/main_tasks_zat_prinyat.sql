/* Formatted on 09/04/2015 12:55:33 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c, full pr, is_accepted ok
    FROM (SELECT NVL (
                    (SELECT COUNT (*)
                       FROM zat_daily_trip
                      WHERE     tn = z1.tn
                            AND TRUNC (data, 'mm') =
                                   (SELECT CASE
                                              WHEN TO_CHAR (SYSDATE, 'dd') < 25
                                              THEN
                                                 ADD_MONTHS (
                                                    TRUNC (SYSDATE, 'mm'),
                                                    -1)
                                              ELSE
                                                 TRUNC (SYSDATE, 'mm')
                                           END
                                      FROM DUAL)),
                    0)
                    daily_trip_plans_count,
                 NVL (
                    (SELECT COUNT (*)
                       FROM zat_daily_car
                      WHERE     tn = z1.tn
                            AND TRUNC (data, 'mm') =
                                   (SELECT CASE
                                              WHEN TO_CHAR (SYSDATE, 'dd') < 25
                                              THEN
                                                 ADD_MONTHS (
                                                    TRUNC (SYSDATE, 'mm'),
                                                    -1)
                                              ELSE
                                                 TRUNC (SYSDATE, 'mm')
                                           END
                                      FROM DUAL)),
                    0)
                    daily_car_plans_count,
                 NVL (
                    (SELECT is_accepted
                       FROM zat_monthly m
                      WHERE     TO_DATE (1 || '.' || m.m || '.' || m.y,
                                         'dd.mm.yyyy') =
                                   (SELECT CASE
                                              WHEN TO_CHAR (SYSDATE, 'dd') < 25
                                              THEN
                                                 ADD_MONTHS (
                                                    TRUNC (SYSDATE, 'mm'),
                                                    -1)
                                              ELSE
                                                 TRUNC (SYSDATE, 'mm')
                                           END
                                      FROM DUAL)
                            AND m.tn = z1.tn),
                    0)
                    is_accepted,
                 NVL (
                    (SELECT is_processed
                       FROM zat_monthly m
                      WHERE     TO_DATE (1 || '.' || m.m || '.' || m.y,
                                         'dd.mm.yyyy') =
                                   (SELECT CASE
                                              WHEN TO_CHAR (SYSDATE, 'dd') < 25
                                              THEN
                                                 ADD_MONTHS (
                                                    TRUNC (SYSDATE, 'mm'),
                                                    -1)
                                              ELSE
                                                 TRUNC (SYSDATE, 'mm')
                                           END
                                      FROM DUAL)
                            AND m.tn = z1.tn),
                    0)
                    is_processed,
                 full
            FROM (SELECT f.full, f.slave tn
                    FROM full f, user_list u
                   WHERE     f.dpt_id = :dpt_id
                         AND f.master = :tn
                         AND u.tn = f.slave
                         AND NVL (u.is_top, 0) <> 1
                         AND NVL (ADD_MONTHS (TRUNC (u.datauvol, 'mm'), 1),
                                  TRUNC (SYSDATE, 'mm')) >=
                                TRUNC (SYSDATE, 'mm')) z1)
GROUP BY full, is_accepted