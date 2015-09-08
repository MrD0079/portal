/* Formatted on 19.02.2013 13:35:46 (QP5 v5.163.1008.3004) */
  SELECT d.tstabnum,
         st.fio fio_ts,
         d.merchname,
         d.jur_nazv,
         d.addr,
         d.kod_tt,
         d.invoice_no,
         TO_CHAR (d.dt, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         an.bonus_qty,
         d.summnds,
         CASE WHEN d.summnds >= 3000 THEN 1 ELSE 0 END action_nakl,
         DECODE (an.h_custcode_kodtt_invoiceno_dt, NULL, 0, 1) selected,
         an.ok_chief,
         an.bonus_text,
         d.h_custcode_kodtt_invoiceno_dt
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