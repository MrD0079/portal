/* Formatted on 12.12.2013 15:33:54 (QP5 v5.227.12220.39724) */
SELECT SUM (cnt) cnt,
       SUM (bonus) bonus,
       SUM (DECODE (f.ok_traid, 1, bonus, 0)) bonus_ok
  FROM a13_nv_files f, user_list st
 WHERE     f.tn = st.tn
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts,
                                   0, DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn),
                                   :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts,
                                   0, DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn),
                                   :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
                           FROM full
                          WHERE master = DECODE (:tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn))
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = DECODE (:tn,
                                    -1, (SELECT MAX (tn)
                                           FROM user_list
                                          WHERE is_admin = 1),
                                    :tn)) = 1)
       AND st.dpt_id = :dpt_id