/* Formatted on 16.12.2013 14:13:19 (QP5 v5.227.12220.39724) */
  SELECT h.id,
         h.dt,
         h.fil,
         f.name fil_name,
         u1.fio lu_fio,
         TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         COUNT (*) c,
         COUNT (DISTINCT stp.id) + COUNT (DISTINCT st.id) c1,
         f.nd,
         u2.fio db_fio,
         u2.region_name db_region,
         SUM (b.zd_fakt) zd_fakt
    FROM bud_ru_cash_out_head h,
         bud_ru_cash_out_body b,
         bud_ru_st_ras st,
         bud_ru_st_ras stp,
         bud_fil f,
         user_list u1,
         user_list u2
   WHERE     h.fil = f.id(+)
         AND h.lu_tn = u1.tn(+)
         AND h.id = b.head_id(+)
         AND h.dt = TO_DATE (:dt, 'dd/mm/yyyy')
         AND h.db = u2.tn(+)
         AND b.st = st.id
         AND st.parent <> 0
         AND st.parent = stp.id
         AND f.dpt_id = :dpt_id
         AND st.dpt_id = :dpt_id
         AND stp.dpt_id = :dpt_id
GROUP BY h.id,
         h.dt,
         h.fil,
         f.name,
         u1.fio,
         h.lu,
         f.nd,
         u2.fio,
         u2.region_name
ORDER BY f.name, h.id