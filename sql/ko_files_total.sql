/* Formatted on 11.01.2013 13:20:34 (QP5 v5.163.1008.3004) */
  SELECT fn_getname ( d.tn) fio_ts, COUNT (*) c1, d.tn
    FROM ko_files d, spdtree st
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
         AND DECODE (:tip,  1, '0',  2, 'b',  3, 'c') = DECODE (:tip, 1, '0', d.tip)
GROUP BY d.tn
ORDER BY fio_ts