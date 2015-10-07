/* Formatted on 07/10/2015 14:57:59 (QP5 v5.252.13127.32867) */
  SELECT z.id,
         z.name,
         z.sw_kod,
         TO_CHAR (z.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (z.data_end, 'dd.mm.yyyy') data_end,
         z.lu_fio,
         z.nd,
         z.rp,
         z.rf,
         z.comm,
         z.login,
         s.password,
         z.sales_team_delivery,
         z.gsm,
         z.bonus_log_koef,
         z.dpt_id,
         z.kk
    FROM bud_fil z, spr_users s
   WHERE     z.dpt_id = :dpt_id
         AND z.login = s.login(+)
         AND NVL (z.data_end, TRUNC (SYSDATE)) >= TRUNC (SYSDATE, 'mm')
ORDER BY z.name