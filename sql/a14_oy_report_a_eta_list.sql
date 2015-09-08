/* Formatted on 24.01.2014 16:30:57 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a14_oy a, a14_oy_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND t.m = :month
ORDER BY a.fio_eta