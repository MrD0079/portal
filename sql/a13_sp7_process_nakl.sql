/* Formatted on 29.07.2013 15:14:38 (QP5 v5.227.12220.39724) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         TO_CHAR (an.bonus_dt, 'dd.mm.yyyy') bonus_dt,
         d.summa,
         NVL( d.s1_1, 0),
         NVL( d.s1_2, 0),
         NVL( d.s1_3, 0),
         NVL( ROUND (d.q2_1), 0) q2_1,
         NVL( ROUND (d.q2_2), 0) q2_2,
         NVL( ROUND (d.q2_3), 0) q2_3,
         CASE
            WHEN NVL( ROUND (d.q2_1), 0) = 1 THEN 1
            WHEN NVL( ROUND (d.q2_1), 0) >= 2 THEN 2
            ELSE NULL
         END
            max_if1,
         CASE
            WHEN NVL( ROUND (d.q2_2), 0) = 1 THEN 1
            WHEN NVL( ROUND (d.q2_2), 0) >= 2 THEN 2
            ELSE NULL
         END
            max_if2,
         CASE
            WHEN NVL( ROUND (d.q2_3), 0) = 1 THEN 1
            WHEN NVL( ROUND (d.q2_3), 0) >= 2 THEN 2
            ELSE NULL
         END
            max_if3,
         CASE WHEN NVL( d.s1_1, 0) = 0 AND NVL( ROUND (d.q2_1), 0) >= 1 THEN 1 ELSE 0 END if1,
         CASE WHEN NVL( d.s1_2, 0) = 0 AND NVL( ROUND (d.q2_2), 0) >= 1 THEN 1 ELSE 0 END if2,
         CASE WHEN NVL( d.s1_3, 0) = 0 AND NVL( ROUND (d.q2_3), 0) >= 1 THEN 1 ELSE 0 END if3,
         an.if1 selected_if1,
         an.if2 selected_if2,
         an.if3 selected_if3,
         an.ok_traid,
         an.ok_chief,
         an.bonus_sum1,
         an.bonus_sum2,
         an.bonus_sum3,
         d.H_TP_KOD_DATA_NAKL
    FROM a13_sp7 d, a13_sp7_action_nakl an, user_list st
   WHERE     d.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND st.dpt_id = :dpt_id
         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
         AND DECODE (:tp, 0, d.H_TP_KOD_DATA_NAKL, 0) =
                DECODE (:tp, 0, an.H_TP_KOD_DATA_NAKL, 0)
         AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
         AND DECODE (
                :tp,
                0, DECODE (NVL (an.if1, 0) + NVL (an.if2, 0) + NVL (an.if3, 0),
                           0, 0,
                           1),
                0) = DECODE (:tp, 0, 1, 0)
         AND d.data BETWEEN TO_DATE ('15.07.2013', 'dd.mm.yyyy')
                        AND TO_DATE ('31.07.2013', 'dd.mm.yyyy')
ORDER BY st.fio,
         d.fio_eta,
         d.data,
         d.tp_ur,
         d.nakl