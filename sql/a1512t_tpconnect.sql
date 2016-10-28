/* Formatted on 12/29/2015 12:06:01  (QP5 v5.252.13127.32867) */
  SELECT tp.*
    FROM A1512T_XLS_TPCLIENT tp, a1512t d, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND st.dpt_id = :dpt_id
         AND tp.tp_kod = d.tp_kod
         AND (h_client = :filter_h_client OR LENGTH ( :filter_h_client) IS NULL)
ORDER BY tp.client, tp.tp_kod