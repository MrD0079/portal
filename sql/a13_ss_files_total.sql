/* Formatted on 11.01.2013 12:46:26 (QP5 v5.163.1008.3004) */
  SELECT SUM (bonus) bonus,
         fn_getname ( d.tn) fio_ts,
         COUNT (*) c1,
         d.tn
    FROM a13_ss_files d, spdtree st
   WHERE     d.tn = st.svideninn
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))

         AND (st.svideninn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)

         AND st.dpt_id = :dpt_id
GROUP BY d.tn
ORDER BY fio_ts