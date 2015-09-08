/* Formatted on 11.01.2013 13:50:16 (QP5 v5.163.1008.3004) */
  SELECT SUM (ya_gel) summa,
         fn_getname ( d.tn) fio_ts,
         COUNT (*) c1,
         d.tn
    FROM val_mart_files d, spdtree st
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
         AND TP_KAT = :tp_KAT
         AND st.dpt_id = :dpt_id
GROUP BY d.tn
ORDER BY fio_ts