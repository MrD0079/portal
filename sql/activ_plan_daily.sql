/* Formatted on 09/04/2015 13:57:46 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (d.DATA, 'dd.mm.yyyy') data,
         d.city,
         d.PLAN,
         d.doc
    FROM p_activ_plan_daily d
   WHERE     d.tn = :tn
         AND TRUNC (d.DATA, 'mm') = TO_DATE (:month_list, 'dd.mm.yyyy')
ORDER BY d.DATA