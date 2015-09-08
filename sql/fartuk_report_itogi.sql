/* Formatted on 19.02.2013 16:21:58 (QP5 v5.163.1008.3004) */
SELECT COUNT (DISTINCT an.h_custcode_kodtt_invoiceno_dt) cnt_nakl,
       COUNT (DISTINCT d.h_custcode_kodtt) cnt_tp,
       SUM (d.summnds) summnds,
       SUM (an.bonus_qty) bonus_qty,
       SUM (an.ok_chief) ok_chief
  FROM fartuk d, fartuk_action_nakl an, user_list st
 WHERE     d.tstabnum = st.tab_num
         AND st.tn IN (SELECT slave
                         FROM full
                        WHERE master = DECODE (:exp_list_without_ts, 0, st.tn, :exp_list_without_ts))
         AND st.tn IN (SELECT slave
                         FROM full
                        WHERE master = DECODE (:exp_list_only_ts, 0, st.tn, :exp_list_only_ts))
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
       AND d.h_custcode_kodtt_invoiceno_dt = an.h_custcode_kodtt_invoiceno_dt
       AND DECODE (:eta_list, '', d.h_merchname, :eta_list) = d.h_merchname
       AND DECODE (:ok_traid,  1, 0,  2, 1) = DECODE (:ok_traid,  1, 0,  2, an.ok_traid)
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
       AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.dt, 'mm')))