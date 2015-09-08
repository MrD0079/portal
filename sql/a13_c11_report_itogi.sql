/* Formatted on 29.04.2013 14:29:44 (QP5 v5.163.1008.3004) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       SUM (d.CHER225Q) CHER225Q,
       SUM (d.CHER420Q) CHER420Q,
       SUM (an.ok_chief) ok_chief,
       SUM (an.bonus_sum1) bonus_sum1,
       SUM (an.bonus_sum2) bonus_sum2,
       AVG ( (SELECT SUM (bonus) bonus
                FROM a13_c11_files f, user_list st
               WHERE     f.ok_traid = 1
                     AND f.tn = st.tn
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
                     AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
                     AND (st.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                          OR (SELECT NVL (is_traid, 0)
                                FROM user_list
                               WHERE tn = :tn) = 1)
                     AND st.dpt_id = :dpt_id))
          files_bonus                                                                               /*,
                                                                                      DECODE (NVL (SUM (d.summa), 0), 0, 0, (SUM (an.bonus_sum1)) / SUM (d.summa)) * 100 zat*/
  FROM a13_c11 d,
       a13_c11_action_nakl an,
       user_list st,
       a13_c11_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
       AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
       AND (st.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
       AND d.tp_kod = tp.tp_kod
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) = DECODE (:ok_chief,  1, 0,  2, an.ok_chief,  3, NVL (an.ok_chief, 0))
       --       AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))
       AND DECODE (NVL (an.if1, 0) + NVL (an.if2, 0), 0, 0, 1) = 1
       AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')
