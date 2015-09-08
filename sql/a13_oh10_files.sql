/* Formatted on 19.09.2013 16:19:13 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (d.lu, 'dd.mm.yyyy hh24:mi:ss') lu_text,
         d.*,
         fn_getname ( d.tn) fio_ts,
         NVL (bonus, 0) bonus,
         TO_CHAR (d.ok_traid_date, 'dd.mm.yyyy hh24:mi:ss') ok_traid_date_text
    FROM a13_oh10_files d, spdtree st
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
ORDER BY fio_ts, d.fn