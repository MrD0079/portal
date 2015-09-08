/* Formatted on 22.02.2013 15:33:37 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a13_7p1 a, a13_7p1_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND t.selected = 1
ORDER BY a.fio_eta