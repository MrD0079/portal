/* Formatted on 28/01/2015 17:55:37 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a150151fk a, a150151fk_tp_select t, user_list st
   WHERE     a.tp_kod = t.tp_kod
         AND a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id and st.is_spd=1
ORDER BY a.fio_eta