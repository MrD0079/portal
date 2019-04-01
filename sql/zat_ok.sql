/* Formatted on 02.11.2016 17:26:01 (QP5 v5.252.13127.32867) */
SELECT ROWNUM,
       z.*,
       (  cost_transp
        + cost_kom
        + present_cost
        + stationery
        + media_advert
        + mail
        + conference
        + training_food
        + esv
        + single_tax
        + account_payments
        + mobile
        + amort)
          total
  FROM (  SELECT DISTINCT
                 s.svideninn emp_tn,
                 s.dolgn emp_dolgn,
                 fn_getname (s.svideninn) emp_name,
                   NVL (
                      (SELECT SUM (
                                   NVL (PET_SUM, 0)
                                 + NVL (OIL_SUM, 0)
                                 + NVL (WASH, 0)
                                 + NVL (SERVICE, 0)
                                 + NVL (PARKING, 0))
                         FROM zat_daily_car zc
                        WHERE     TRUNC (zc.data, 'mm') =
                                     TO_DATE ( :sd, 'dd.mm.yyyy')
                              AND zc.tn = s.svideninn),
                      0)
                 + NVL (zm.gbo_warmup_sum, 0)
                    cost_transp,
                 NVL (
                    (SELECT SUM (
                                 +NVL (DAILY_COST, 0)
                               + NVL (FOOD, 0)
                               + NVL (HOTEL, 0)
                               + NVL (TRANSPORT, 0))
                       FROM zat_daily_trip zt
                      WHERE     TRUNC (zt.data, 'mm') =
                                   TO_DATE ( :sd, 'dd.mm.yyyy')
                            AND zt.tn = s.svideninn),
                    0)
                    cost_kom,
                 NVL (zm.PRESENT_COST, 0) present_cost,
                 NVL (zm.STATIONERY, 0) stationery,
                 NVL (zm.MEDIA_ADVERT, 0) media_advert,
                 NVL (zm.MAIL, 0) mail,
                 NVL (zm.CONFERENCE, 0) conference,
                 NVL (zm.TRAINING_FOOD, 0) training_food,
                 NVL (zm.ESV, 0) esv,
                 NVL (zm.SINGLE_TAX, 0) single_tax,
                 NVL (zm.account_payments, 0) account_payments,
                 NVL (zm.mobile, 0) mobile,
                 NVL (zm.AMORT, 0) amort,
                 NVL (zm.gbo_warmup_sum, 0) gbo_warmup_sum,
                 NVL (
                    (SELECT is_accepted
                       FROM zat_monthly m, calendar c
                      WHERE     m.m = c.my
                            AND m.y = c.y
                            AND c.DATA = TO_DATE ( :sd, 'dd.mm.yyyy')
                            AND m.tn = s.svideninn),
                    0)
                    zat_monthly_is_accepted,
                 NVL (
                    (SELECT is_processed
                       FROM zat_monthly m, calendar c
                      WHERE     m.m = c.my
                            AND m.y = c.y
                            AND c.DATA = TO_DATE ( :sd, 'dd.mm.yyyy')
                            AND m.tn = s.svideninn),
                    0)
                    zat_monthly_is_processed,
                 CASE
                    WHEN :exp_tn = 0
                    THEN
                       0
                    ELSE
                       (SELECT exp_tn
                          FROM emp_exp
                         WHERE     full = 0
                               AND exp_tn <> emp_tn
                               AND emp_tn = s.svideninn
                               AND exp_tn = :exp_tn)
                 END
                    exp_tn_compare,
                 NVL (zm.avans, 0) avans,
                 NVL (zm.accepted_in_time, 0) accepted_in_time,
                 TO_CHAR (s.datauvol, 'dd.mm.yyyy') datauvol,
                 TO_CHAR (zm.dt, 'dd.mm.yyyy') rep_date,
                 zm.y,
                 zm.m
            FROM spdtree s,
                 (SELECT z.*,
                         TO_DATE ('01.' || z.m || '.' || z.y, 'dd.mm.yyyy') dt
                    FROM zat_monthly z
                   WHERE    TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') =
                               TO_DATE ( :sd, 'dd.mm.yyyy')
                         OR (    TO_DATE ('01.' || m || '.' || y, 'dd.mm.yyyy') =
                                    ADD_MONTHS (TO_DATE ( :sd, 'dd.mm.yyyy'),
                                                -1)
                             AND accepted_in_time = 0)) zm
           WHERE     s.dpt_id = :dpt_id
                 AND s.svideninn = zm.tn(+)
                 AND NVL (s.is_top, 0) <> 1
                 AND NVL (TRUNC (s.datauvol, 'mm'),
                          TO_DATE ( :sd, 'dd.mm.yyyy')) >=
                        TO_DATE ( :sd, 'dd.mm.yyyy')
        ORDER BY emp_name, zm.y, zm.m) z
 WHERE     INSTR ( :is_accepted, TO_CHAR (zat_monthly_is_accepted)) > 0
       /*AND INSTR ( :is_processed, TO_CHAR (zat_monthly_is_processed)) > 0*/
       AND exp_tn_compare = :exp_tn