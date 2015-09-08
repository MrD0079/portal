/* Formatted on 29/08/2013 14:56:48 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (d.lu, 'dd.mm.yyyy hh24:mi:ss') lu_text,
         d.*,
         fn_getname ( d.tn) fio_ts,
         NVL (bonus, 0) summa
    FROM a13_va8_files d, spdtree st
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
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND st.dpt_id = :dpt_id
         AND DECODE (:ok_traid,  1, 0,  2, 1) =
                DECODE (:ok_traid,  1, 0,  2, d.ok_traid)
ORDER BY fio_ts, d.fn