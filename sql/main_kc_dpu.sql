/* Formatted on 22.10.2014 11:21:01 (QP5 v5.227.12220.39724) */
  SELECT c.mt || ' ' || c.y dt, TO_CHAR (c.data, 'dd.mm.yyyy') data
    FROM kcm k, calendar c
   WHERE     k.dpt_id = :dpt_id
         AND ok_dpu_tn IS NULL
         AND c.data = k.dt
         AND k.it_perc IS NOT NULL
ORDER BY k.dt