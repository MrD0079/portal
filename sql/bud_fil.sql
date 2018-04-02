/* Formatted on 16/06/2015 11:29:58 (QP5 v5.227.12220.39724) */
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
         z.kk,
         z.nacenka_base0
    FROM bud_fil z, spr_users s
   WHERE z.dpt_id = :dpt_id AND z.login = s.login(+)
ORDER BY z.name