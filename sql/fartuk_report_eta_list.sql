/* Formatted on 19.02.2013 15:42:51 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.H_MERCHNAME, a.MERCHNAME
    FROM fartuk a,
         fartuk_tp_select t,
         user_list st,
         fartuk_action_nakl an
   WHERE     a.h_custcode_kodtt = t.h_custcode_kodtt
         AND a.h_custcode_kodtt_invoiceno_dt = an.h_custcode_kodtt_invoiceno_dt
         AND a.tstabnum = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
)
         AND st.dpt_id = :dpt_id
         AND t.selected = 1
ORDER BY a.MERCHNAME