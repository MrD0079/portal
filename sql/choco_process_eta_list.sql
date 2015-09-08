/* Formatted on 04.02.2013 14:06:11 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM choco_box a, choco_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
/*         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)*/
         AND (st.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         --AND st.tn = :tn
         AND st.dpt_id = :dpt_id
         AND t.selected = 1
ORDER BY a.fio_eta