/* Formatted on 03.06.2018 11:32:38 (QP5 v5.252.13127.32867) */
  SELECT TO_CHAR (c.DATA, 'dd.mm.yyyy') data,
         d.city,
         d.PLAN,
         d.doc
    FROM p_activ_plan_daily d, calendar c
   WHERE     c.data = d.data(+)
         AND :tn = d.tn(+)
         AND TO_DATE ( :month_list, 'dd.mm.yyyy') = TRUNC (c.data, 'mm')
ORDER BY d.DATA