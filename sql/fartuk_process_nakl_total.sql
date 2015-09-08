/* Formatted on 19.02.2013 13:47:22 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c1, SUM (d.summnds) summnds, SUM (an.bonus_qty) bonus_qty
    FROM fartuk d, fartuk_action_nakl an, user_list st
   WHERE     d.tstabnum = st.tab_num
         AND (st.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.h_custcode_kodtt, :tp) = d.h_custcode_kodtt
         AND DECODE (:tp, 0, d.h_custcode_kodtt_invoiceno_dt, 0) = DECODE (:tp, 0, an.h_custcode_kodtt_invoiceno_dt, 0)
         AND d.h_custcode_kodtt_invoiceno_dt = an.h_custcode_kodtt_invoiceno_dt(+)
         AND DECODE (:eta_list, '', d.h_merchname, :eta_list) = d.h_merchname
ORDER BY st.fio,
         d.merchname,
         d.dt,
         d.jur_nazv,
         d.invoice_no