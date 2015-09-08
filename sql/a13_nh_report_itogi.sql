/* Formatted on 04/11/2013 9:48:35 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       /*SUM (d.boxqtyc1) boxqtyc1,
       SUM (d.boxqtyc2) boxqtyc2,
       SUM (d.boxqtysah) boxqtysah,*/




       COUNT (DISTINCT DECODE (CASE WHEN boxqtyc1 >= 7 THEN 1 END, 1, tp.tp_kod, NULL)) bonus_cnt_u1,
       COUNT (DISTINCT DECODE (CASE WHEN (boxqtyc1 >= 7 AND boxqtyc2 >= 3) THEN 1 END, 1, tp.tp_kod, NULL)) bonus_cnt_u2,
       COUNT (DISTINCT DECODE (CASE WHEN boxqtysah >= 200 THEN 1 END, 1, tp.tp_kod, NULL)) bonus_cnt_u3,




       COUNT (DISTINCT DECODE (an.bonus_type, 1, tp.tp_kod, NULL)) bonus_cnt1,
       COUNT (DISTINCT DECODE (an.bonus_type, 2, tp.tp_kod, NULL)) bonus_cnt2,
       SUM (DECODE (an.bonus_type, 1, bonus_sum1, NULL)) bonus_sum1,
       SUM (DECODE (an.bonus_type, 2, bonus_sum1, NULL)) bonus_sum2,
         SUM (DECODE (an.bonus_type, 1, bonus_sum1, NULL)) * 100
       + SUM (DECODE (an.bonus_type, 2, bonus_sum1, NULL))
          bonus_sum,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM (an.ok_chief) ok_chief,
       SUM (an.ok_traid) ok_traid,
         DECODE (NVL (SUM (d.summa), 0),
                 0, 0,
                 (SUM (an.bonus_sum1)) / SUM (d.summa))
       * 100
          zat
  FROM a13_nh d,
       a13_nh_action_nakl an,
       user_list st,
       a13_nh_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts,
                                   0, DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn),
                                   :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts,
                                   0, DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn),
                                   :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
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
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
              DECODE (:ok_chief,
                      1, 0,
                      2, an.ok_chief,
                      3, NVL (an.ok_chief, 0))
       --       AND DECODE (:act_month, 0, 0, :act_month) = DECODE (:act_month, 0, 0, TO_NUMBER (TO_CHAR (d.data, 'mm')))
       AND DECODE (NVL (an.if1, 0), 0, 0, 1) = 1
/*       AND d.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/