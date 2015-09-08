/* Formatted on 09/04/2015 13:57:55 (QP5 v5.227.12220.39724) */
SELECT ROWNUM, plan_ok, msg
  FROM p_activ_plan_monthly
 WHERE     tn = :tn
       AND TO_DATE ('01' || '.' || m || '.' || y, 'dd.mm.yy') =
              TO_DATE (:month_list, 'dd.mm.yyyy')