/* Formatted on 05/01/2015 19:14:55 (QP5 v5.227.12220.39724) */
  SELECT c.mt || ' ' || c.y dt, TO_CHAR (c.data, 'dd.mm.yyyy') data
    FROM bud_fil_discount_head k, calendar c
   WHERE k.tn IS NOT NULL AND k.dpu_tn IS NULL AND c.data = k.dt
ORDER BY k.dt