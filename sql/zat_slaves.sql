/* Formatted on 09/04/2015 12:52:50 (QP5 v5.227.12220.39724) */
  SELECT tn,
         emp_name,
         emp_svid,
         zat_monthly_is_accepted,
         zat_monthly_is_processed,
         zat_daily_car_count,
         zat_daily_trip_count,
         MIN (readonly) readonly,
         MAX (full) full,
         DECODE (zat_daily_car_count + zat_daily_trip_count, 0, 0, 1)
            zat_zapolnen
    FROM (  SELECT tn,
                   fn_getname (tn) emp_name,
                   tn emp_svid,
                   NVL (
                      (SELECT is_accepted
                         FROM zat_monthly m, calendar c
                        WHERE     m.m = c.my
                              AND m.y = c.y
                              AND c.DATA = TO_DATE (:sd, 'dd.mm.yyyy')
                              AND m.tn = e.tn),
                      0)
                      zat_monthly_is_accepted,
                   NVL (
                      (SELECT is_processed
                         FROM zat_monthly m, calendar c
                        WHERE     m.m = c.my
                              AND m.y = c.y
                              AND c.DATA = TO_DATE (:sd, 'dd.mm.yyyy')
                              AND m.tn = e.tn),
                      0)
                      zat_monthly_is_processed,
                   (SELECT COUNT (*)
                      FROM zat_daily_car
                     WHERE     tn = e.tn
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
                                     FROM DUAL))
                      zat_daily_car_count,
                   (SELECT COUNT (*)
                      FROM zat_daily_trip
                     WHERE     tn = e.tn
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
                                     FROM DUAL))
                      zat_daily_trip_count,
                   DECODE (e.full, 1, 0, 1) readonly,
                   e.full
              FROM (SELECT DISTINCT f.full, f.slave tn
                      FROM full f, user_list u
                     WHERE     f.dpt_id = :dpt_id
                           AND f.master = :tn
                           AND u.tn = f.slave
                           AND NVL (u.is_top, 0) <> 1
                           AND NVL (ADD_MONTHS (TRUNC (u.datauvol, 'mm'), 1),
                                    TO_DATE (:sd, 'dd.mm.yyyy')) >=
                                  TO_DATE (:sd, 'dd.mm.yyyy')) e
          ORDER BY emp_name) z
   WHERE full >= 0
GROUP BY tn,
         emp_name,
         emp_svid,
         zat_monthly_is_accepted,
         zat_monthly_is_processed,
         zat_daily_car_count,
         zat_daily_trip_count
ORDER BY emp_name