/* Formatted on 31.01.2014 10:03:01 (QP5 v5.227.12220.39724) */
  SELECT h.id,
         TO_CHAR (h.dt, 'dd.mm.yyyy') dt,
         h.fil,
         f.name fil_name,
         u1.fio lu_fio,
         TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (h.ok_fil_lu, 'dd.mm.yyyy hh24:mi:ss') ok_fil_lu,
         h.ok_fil_text,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         COUNT (*) c,
         nd.name nd,
         u2.fio db_fio,
         u2.region_name db_region
    FROM bud_ru_cash_in_head h,
         bud_ru_cash_in_body b,
         bud_fil f,
         user_list u1,
         user_list u2,
         bud_ru_st_pri st,
         bud_nd nd
   WHERE     f.nd = nd.id(+)
         AND h.fil = f.id(+)
         AND h.lu_tn = u1.tn(+)
         AND h.id = b.head_id(+)
         AND h.dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                      AND TO_DATE (:ed, 'dd/mm/yyyy')
         AND h.db = u2.tn(+)
         AND b.st = st.id
         /*:st_pri*/
         AND DECODE (:db, 0, 0, :db) = DECODE (:db, 0, 0, h.db)
         AND DECODE (:fil, 0, 0, :fil) = DECODE (:fil, 0, 0, h.fil)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u2.region_name)
         AND DECODE (:nd, 0, 0, :nd) = DECODE (:nd, 0, 0, f.nd)
         AND f.dpt_id = :dpt_id
         AND st.dpt_id = :dpt_id
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
         u2.region_name,
         nd.name
ORDER BY f.name, h.dt, h.id