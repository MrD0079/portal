/* Formatted on 18.02.2013 16:49:35 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT a.H_MERCHNAME, a.MERCHNAME
    FROM fartuk a, fartuk_tp_select t, user_list st
   WHERE     a.h_custcode_kodtt = t.h_custcode_kodtt
         AND a.tstabnum = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND t.selected = 1
ORDER BY a.MERCHNAME