/* Formatted on 19.08.2017 12:39:34 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a1802cm a, a1802cm_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
ORDER BY a.fio_eta