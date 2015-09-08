/* Formatted on 25.10.2013 9:39:10 (QP5 v5.227.12220.39724) */
SELECT SUM (b.plan) plan, SUM (b.fakt) fakt, COUNT (*) c
  FROM bud_ru_cash_in_head h,
       bud_ru_cash_in_body b,
       bud_fil f,
       user_list u1
 WHERE     h.fil = f.id(+)
       AND h.lu_tn = u1.tn(+)
       AND h.id = b.head_id(+)
       AND h.dt = TO_DATE (:dt, 'dd/mm/yyyy')
 and f.dpt_id=:dpt_id
