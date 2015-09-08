/* Formatted on 09/04/2015 13:05:47 (QP5 v5.227.12220.39724) */
  SELECT ROWNUM, z.*
    FROM (  SELECT s.pos_name emp_dolgn,
                   s.pos_id emp_dolgn_id,
                   s.fio emp_name,
                   s.tn emp_tn,
                   NVL (
                      (SELECT   NVL (TICKETS, 0)
                              + NVL (PRESENT_COST, 0)
                              + NVL (STATIONERY, 0)
                              + NVL (MEDIA_ADVERT, 0)
                              + NVL (MAIL, 0)
                              + NVL (CONFERENCE, 0)
                              + NVL (TRAINING_FOOD, 0)
                              + NVL (ESV, 0)
                              + NVL (SINGLE_TAX, 0)
                              + NVL (ODOMETR_START, 0)
                              + NVL (ODOMETR_END, 0)
                              + NVL (ACCOUNT_PAYMENTS, 0)
                              + NVL (MOBILE, 0)
                         FROM zat_monthly m, calendar c
                        WHERE     m.tn = s.tn
                              AND c.DATA = TO_DATE (:DATA, 'dd.mm.yyyy')
                              AND c.my = m.m
                              AND c.y = m.y),
                      0)
                      zat_monthly_exist,
                   (SELECT COUNT (*)
                      FROM zat_daily_car
                     WHERE     tn = s.tn
                           AND TRUNC (DATA, 'mm') = TO_DATE (:DATA, 'dd.mm.yyyy'))
                      zat_daily_car_count,
                   (SELECT COUNT (*)
                      FROM zat_daily_trip
                     WHERE     tn = s.tn
                           AND TRUNC (DATA, 'mm') = TO_DATE (:DATA, 'dd.mm.yyyy'))
                      zat_daily_trip_count,
                   TO_CHAR (s.datauvol, 'dd.mm.yyyy') datauvol
              FROM user_list s
             WHERE     s.dpt_id = :dpt_id
                   AND NVL (s.is_top, 0) <> 1
                   AND NVL (TRUNC (s.datauvol, 'mm'),
                            TO_DATE (:DATA, 'dd.mm.yyyy')) >=
                          TO_DATE (:DATA, 'dd.mm.yyyy')
                   AND s.is_spd = 1
          ORDER BY emp_name) z
   WHERE     :dolgn_id = DECODE (:dolgn_id, 0, 0, emp_dolgn_id)
         AND :exist_daily_zat_count =
                DECODE (
                   :exist_daily_zat_count,
                   0, :exist_daily_zat_count,
                   1, DECODE (
                           zat_daily_car_count
                         + zat_daily_trip_count
                         + zat_monthly_exist,
                         0, 0,
                         1),
                   -1, DECODE (
                            zat_daily_car_count
                          + zat_daily_trip_count
                          + zat_monthly_exist,
                          0, -1,
                          0))
ORDER BY emp_name