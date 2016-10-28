/* Formatted on 12/22/2015 3:18:08  (QP5 v5.252.13127.32867) */
  SELECT st.fio ts_fio,
         d.fio_eta fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.tp_addr
    FROM A1512T_XLS_SALESPLAN sp,
         A1512T_XLS_TPCLIENT tp,
         a1512t d,
         user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = DECODE ( :tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE ( :eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND st.dpt_id = :dpt_id
         AND sp.H_client = tp.H_client
         AND tp.tp_kod = d.tp_kod
         AND :h_client = sp.H_client
ORDER BY st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr