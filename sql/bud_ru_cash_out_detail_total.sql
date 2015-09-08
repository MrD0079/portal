/* Formatted on 11.11.2013 14:46:56 (QP5 v5.227.12220.39724) */
SELECT SUM (b.plan) plan,
       SUM (b.fakt) fakt,
       SUM (b.zd_fakt) zd_fakt,
       COUNT (*) c
  FROM bud_ru_cash_out_head h,
       bud_ru_cash_out_body b,
       bud_fil f,
       user_list u1
 WHERE     h.fil = f.id(+)
       AND h.lu_tn = u1.tn(+)
       AND h.id = b.head_id(+)
       AND h.dt = TO_DATE (:dt, 'dd/mm/yyyy')
       AND f.dpt_id = :dpt_id