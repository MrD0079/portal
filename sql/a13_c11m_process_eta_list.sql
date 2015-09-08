/* Formatted on 18.05.2013 13:26:48 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a13_c11 a, a13_c11m_tp_select t, user_list st
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
         AND a.data BETWEEN TO_DATE ('13.05.2013', 'dd.mm.yyyy') AND TO_DATE ('31.05.2013', 'dd.mm.yyyy')
ORDER BY a.fio_eta