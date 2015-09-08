/* Formatted on 10.12.2014 17:19:52 (QP5 v5.227.12220.39724) */
  SELECT st.*,
         d.fio_eta,
         d.tp_name,
         d.tp_kod,
         d.tp_kod_sw,
         d.p10,
         d.b10,
         d.p11,
         d.b11,
         d.p12,
         d.b12
    FROM a14ss_pb d, user_list st
   WHERE     d.tab_num = st.tab_num
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND st.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
ORDER BY fio_rm,
         fio_tm,
         fio_ts,
         fio_eta,
         tp_name