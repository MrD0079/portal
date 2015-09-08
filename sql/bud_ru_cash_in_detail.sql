/* Formatted on 16.12.2013 14:01:17 (QP5 v5.227.12220.39724) */
  SELECT h.id,
         h.dt,
         h.fil,
         f.name fil_name,
         u1.fio lu_fio,
         TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (h.ok_fil_lu, 'dd.mm.yyyy hh24:mi:ss') ok_fil_lu,
         h.ok_fil_text,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         COUNT (*) c,
         f.nd,
         u2.fio db_fio,
         u2.region_name db_region
    FROM bud_ru_cash_in_head h,
         bud_ru_cash_in_body b,
         bud_fil f,
         user_list u1,
         user_list u2
   WHERE     h.fil = f.id(+)
         AND h.lu_tn = u1.tn(+)
         AND h.id = b.head_id(+)
         AND h.dt = TO_DATE (:dt, 'dd/mm/yyyy')
         AND h.db = u2.tn(+)
         AND f.dpt_id = :dpt_id
GROUP BY h.id,
         h.dt,
         h.fil,
         f.name,
         u1.fio,
         h.lu,
         h.ok_fil_lu,
         h.ok_fil_text,
         f.nd,
         u2.fio,
         u2.region_name
ORDER BY f.name, h.id