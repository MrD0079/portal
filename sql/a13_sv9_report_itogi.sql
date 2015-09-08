/* Formatted on 25.09.2013 11:46:02 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT tp_kod) cnt_tp,
       COUNT (DISTINCT H_TP_KOD_DATA_NAKL) cnt_nakl,
       SUM (CASE WHEN c1 = 1 AND c = 1 THEN 1 ELSE 0 END) cnt_nakl1,
       SUM (CASE WHEN c2 = 1 AND c = 2 THEN 1 ELSE 0 END) cnt_nakl2,
       SUM (CASE WHEN c3 = 1 AND c = 3 THEN 1 ELSE 0 END) cnt_nakl3,
       SUM (summa) summa,
       SUM (sumveskonf) sumveskonf,
       SUM (ok_chief) ok_chief,
       SUM (ok_traid) ok_traid,
       SUM (CASE WHEN c1 = 1 AND c = 1 THEN bonus_sum1 ELSE 0 END)
          bonus_sum_c1,
       SUM (CASE WHEN c2 = 1 AND c = 2 THEN bonus_sum1 ELSE 0 END)
          bonus_sum_c2,
       SUM (CASE WHEN c3 = 1 AND c = 3 THEN bonus_sum1 ELSE 0 END)
          bonus_sum_c3,
         SUM (CASE WHEN c1 = 1 AND c = 1 THEN bonus_sum1 ELSE 0 END)
       + SUM (CASE WHEN c2 = 1 AND c = 2 THEN bonus_sum1 ELSE 0 END)
       + SUM (CASE WHEN c3 = 1 AND c = 3 THEN bonus_sum1 ELSE 0 END)
          bonus_sum_all,
         DECODE (
            NVL (SUM (summa), 0),
            0, 0,
              (  SUM (CASE WHEN c1 = 1 AND c = 1 THEN bonus_sum1 ELSE 0 END)
               + SUM (CASE WHEN c2 = 1 AND c = 2 THEN bonus_sum1 ELSE 0 END)
               + SUM (CASE WHEN c3 = 1 AND c = 3 THEN bonus_sum1 ELSE 0 END))
            / SUM (summa))
       * 100
          zat
  FROM (SELECT an.H_TP_KOD_DATA_NAKL,
               tp.tp_kod,
               d.summa,
               CASE
                  WHEN    d.cond1 = 1
                       OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
                  THEN
                     1
                  ELSE
                     0
               END
                  c1,
               CASE
                  WHEN    d.cond2 = 1
                       OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
                  THEN
                     1
                  ELSE
                     0
               END
                  c2,
               CASE
                  WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300) THEN 1
                  ELSE 0
               END
                  c3,
               CASE
                  WHEN d.cond3 = 1 OR (d.sumveskonf >= 2300)
                  THEN
                     3
                  WHEN    d.cond2 = 1
                       OR (d.sumveskonf >= 1800 AND d.sumveskonf < 2300)
                  THEN
                     2
                  WHEN    d.cond1 = 1
                       OR (d.sumveskonf >= 1400 AND d.sumveskonf < 1800)
                  THEN
                     1
                  ELSE
                     0
               END
                  c,
               CASE
                  WHEN    d.cond1 = 1
                       OR d.cond2 = 1
                       OR d.cond3 = 1
                       OR d.sumveskonf >= 1400
                  THEN
                     1
                  ELSE
                     0
               END
                  if1,
               d.sumveskonf,
               an.ok_chief,
               an.ok_traid,
               an.bonus_sum1
          FROM a13_sv9 d,
               a13_sv9_action_nakl an,
               user_list st,
               a13_sv9_tp_select tp
         WHERE     d.tab_num = st.tab_num
               AND st.tn IN
                      (SELECT slave
                                 FROM full
                                WHERE master =
                                 DECODE (
                                    :exp_list_without_ts,
                                    0, DECODE (:tn,
                                               -1, (SELECT MAX (tn)
                                                      FROM user_list
                                                     WHERE is_admin = 1),
                                               :tn),
                                    :exp_list_without_ts))
               AND st.tn IN
                      (SELECT slave
                                 FROM full
                                WHERE master =
                                 DECODE (
                                    :exp_list_only_ts,
                                    0, DECODE (:tn,
                                               -1, (SELECT MAX (tn)
                                                      FROM user_list
                                                     WHERE is_admin = 1),
                                               :tn),
                                    :exp_list_only_ts))
               AND (   st.tn IN
                          (SELECT slave
                             FROM full
                            WHERE master = DECODE (:tn,
                                                   -1, (SELECT MAX (tn)
                                                          FROM user_list
                                                         WHERE is_admin = 1),
                                                   :tn))
                    OR (SELECT NVL (is_traid, 0)
                          FROM user_list
                         WHERE tn = DECODE (:tn,
                                            -1, (SELECT MAX (tn)
                                                   FROM user_list
                                                  WHERE is_admin = 1),
                                            :tn)) = 1)
               AND st.dpt_id = :dpt_id
               AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
               AND d.tp_kod = tp.tp_kod
               AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) =
                      d.h_fio_eta
               AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                      DECODE (:ok_chief,
                              1, 0,
                              2, an.ok_chief,
                              3, NVL (an.ok_chief, 0))
               /*AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))*/
               AND DECODE (NVL (an.if1, 0), 0, 0, 1) = 1 /*AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
                                                        )