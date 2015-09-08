/* Formatted on 15.01.2015 17:36:04 (QP5 v5.227.12220.39724) */
  SELECT c.mt || ' ' || c.y dt,
         TO_CHAR (c.data, 'dd.mm.yyyy') data,
         NVL (k.kk, 0) kk,
         DECODE (NVL (k.kk, 0), 0, 'À–', '  ') TYPE
    FROM bud_funds_limits_h k, calendar c
   WHERE     k.ok_traid = 1
         AND NVL (k.ok_dpu, 0) = 0
         AND c.data = k.dt
         AND dpt_id = :dpt_id
ORDER BY k.dt