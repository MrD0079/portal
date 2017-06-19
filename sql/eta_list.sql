/* Formatted on 09/04/2015 17:31:13 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT t.eta fio_eta, t.h_eta h_fio_eta
    FROM routes t, user_list st
   WHERE     t.tab_number = st.tab_num
         AND t.dpt_id = st.dpt_id
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
and st.is_spd=1
ORDER BY t.eta