/* Formatted on 09/04/2015 13:58:16 (QP5 v5.227.12220.39724) */
  SELECT p_activ_type_id, SUM (PLAN) PLAN, SUM (fakt) fakt
    FROM p_activ_plan_weekly
   WHERE     tn = :tn
         AND TO_DATE ('01' || '.' || m || '.' || y, 'dd.mm.yy') =
                TO_DATE (:month_list, 'dd.mm.yyyy')
GROUP BY p_activ_type_id
ORDER BY p_activ_type_id