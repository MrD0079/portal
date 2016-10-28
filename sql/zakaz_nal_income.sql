/* Formatted on 09/11/2015 17:21:27 (QP5 v5.252.13127.32867) */
  SELECT u.tn,
         u.fio,
         ptm.income_sum,
         TO_CHAR (ptm.income_dt, 'dd.mm.yyyy') income_dt
    FROM user_list u, promo_tm ptm
   WHERE     :y = ptm.year(+)
         AND :plan_month = ptm.month(+)
         AND u.tn = ptm.tn(+)
         AND u.is_db = 1
         AND u.is_kk = 1
         AND u.datauvol IS NULL
ORDER BY u.fio