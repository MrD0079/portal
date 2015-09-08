/* Formatted on 23.07.2012 16:28:42 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.fio_eta
    FROM hot_aug a, hot_aug_tp_select t, user_list st
   WHERE     a.TP_KOD = t.TP_KOD
         AND a.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.tn = :tn
         AND st.dpt_id = :dpt_id
ORDER BY a.fio_eta