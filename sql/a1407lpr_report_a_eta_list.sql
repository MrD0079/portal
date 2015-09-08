/* Formatted on 25/07/2014 16:15:21 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT a.eta, a.h_eta
    FROM (SELECT DISTINCT eta, h_eta, tab_number
            FROM routes r, departments d
           WHERE d.manufak = r.country AND d.dpt_id = :dpt_id) a,
         user_list st
   WHERE     a.tab_number = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
ORDER BY a.eta