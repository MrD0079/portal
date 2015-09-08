/* Formatted on 23.07.2012 16:28:42 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.fio_eta
    FROM a4p1 a, a7p1_10_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.dpt_id = :dpt_id
         and t.selected=1
ORDER BY a.fio_eta