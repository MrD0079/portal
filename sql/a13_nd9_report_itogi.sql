/* Formatted on 19.09.2013 14:54:39 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       SUM (d.qty_assorti) qty_assorti,
       SUM (d.qty_vechzol) qty_vechzol,
       SUM (d.qty_shedevr) qty_shedevr,
       SUM (d.qty_domior) qty_domior,
       SUM (an.ok_chief) ok_chief,
       SUM (an.ok_traid) ok_traid,
       SUM (an.bonus_sum1) bonus_sum1,
       SUM (an.bonus_sum1 * 8.9) bonus_sum,
         DECODE (NVL (SUM (d.summa), 0),
                 0, 0,
                 (SUM (an.bonus_sum1)) / SUM (d.summa))
       * 100
          zat
  FROM a13_nd9 d,
       a13_nd9_action_nakl an,
       user_list st,
       a13_nd9_tp_select tp
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