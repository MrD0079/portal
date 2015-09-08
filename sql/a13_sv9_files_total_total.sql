/* Formatted on 24.09.2013 15:32:08 (QP5 v5.227.12220.39724) */
SELECT SUM (bonus) bonus, SUM (cnt) cnt
  FROM a13_sv9_files d, spdtree st
 WHERE     d.tn = st.svideninn
       AND st.svideninn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, :tn,
                                 :exp_list_without_ts))
       AND st.svideninn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, :tn,
                                 :exp_list_only_ts))
       AND (   st.svideninn IN (SELECT slave
                                  FROM full
                                 WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id