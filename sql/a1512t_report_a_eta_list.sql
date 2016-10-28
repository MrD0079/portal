/* Formatted on 12/21/2015 3:34:48  (QP5 v5.252.13127.32867) */
  SELECT DISTINCT a.fio_eta, a.h_fio_eta
    FROM a1512t a, user_list st
   WHERE     a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
ORDER BY a.fio_eta