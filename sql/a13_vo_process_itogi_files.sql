/* Formatted on 19.11.2013 15:29:30 (QP5 v5.227.12220.39724) */
SELECT SUM (bonus) bonus_total,
       SUM (DECODE (ok_traid, 1, bonus, NULL)) bonus_traid
  FROM a13_vo_files st
 WHERE     st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, :tn,
                                 :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, :tn,
                                 :exp_list_only_ts))
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND st.m = :month