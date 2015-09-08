/* Formatted on 11.01.2013 12:43:44 (QP5 v5.163.1008.3004) */
SELECT SUM (NVL (ya_p, 0)) + SUM (NVL (ya_kk, 0)) summa, COUNT (*) c1
  FROM a51_files d, spdtree st
 WHERE     d.tn = st.svideninn
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND st.dpt_id = :dpt_id