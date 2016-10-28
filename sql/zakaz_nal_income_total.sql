/* Formatted on 09/11/2015 17:32:40 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c, SUM (ptm.income_sum) income_sum
  FROM user_list u, promo_tm ptm
 WHERE     :y = ptm.year(+)
       AND :plan_month = ptm.month(+)
       AND u.tn = ptm.tn(+)
       AND u.is_db = 1
       AND u.is_kk = 1
       AND u.datauvol IS NULL