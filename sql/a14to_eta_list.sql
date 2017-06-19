/* Formatted on 09/04/2015 18:13:10 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta, r.eta
    FROM routes r, user_list st
   WHERE     r.tab_number = st.tab_num
         AND r.dpt_id = :dpt_id
         AND st.dpt_id = :dpt_id
      and st.is_spd=1
   AND (   st.tn IN
                    (SELECT slave
                       FROM full
                      WHERE master IN
                               (SELECT parent
                                  FROM assist
                                 WHERE child = :tn AND dpt_id = :dpt_id
                                UNION
                                SELECT DECODE (:tn, -1, master, :tn) FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY r.eta