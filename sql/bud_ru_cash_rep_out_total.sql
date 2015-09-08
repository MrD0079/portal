/* Formatted on 31.01.2014 10:03:55 (QP5 v5.227.12220.39724) */
SELECT SUM (b.plan) plan,
       SUM (b.fakt) fakt,
       SUM (b.zd_fakt) zd_fakt,
       COUNT (*) c
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
       AND h.dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                    AND TO_DATE (:ed, 'dd/mm/yyyy')
       AND h.db = u2.tn(+)
       AND DECODE (:db, 0, 0, :db) = DECODE (:db, 0, 0, h.db)
       AND DECODE (:fil, 0, 0, :fil) = DECODE (:fil, 0, 0, h.fil)
       AND DECODE (:region_name, '0', '0', :region_name) =
              DECODE (:region_name, '0', '0', u2.region_name)
       AND DECODE (:nd, 0, 0, :nd) = DECODE (:nd, 0, 0, f.nd)
       AND b.st = st.id
       AND st.parent <> 0
       AND st.parent = stp.id
       /*:st_ras*/
       /*:kat*/
       AND f.dpt_id = :dpt_id
       AND st.dpt_id = :dpt_id
       AND stp.dpt_id = :dpt_id