/* Formatted on 20.06.2013 9:19:49 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT DECODE (an.if1, 1, an.H_TP_KOD_DATA_NAKL, NULL))
          cnt_nakl1,
       COUNT (DISTINCT DECODE (an.if2, 1, an.H_TP_KOD_DATA_NAKL, NULL))
          cnt_nakl2,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       SUM (an.ok_chief) ok_chief,
       SUM (an.bonus_sum1) bonus_sum1,
       SUM (an.bonus_sum2) bonus_sum2,
       SUM (an.bonus_sum1) + SUM (an.bonus_sum2) bonus_sum,
         COUNT (DISTINCT DECODE (an.bonus_dt1, null, null ,an.H_TP_KOD_DATA_NAKL))
       + COUNT (DISTINCT DECODE (an.bonus_dt2, null, null ,an.H_TP_KOD_DATA_NAKL))
          bonus_cnt,
       AVG (
          (SELECT SUM (bonus) bonus
             FROM a13_ss8_files f, user_list st
            WHERE     f.ok_traid = 1
                  AND f.tn = st.tn
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
                  AND st.dpt_id = :dpt_id))
          files_bonus,
         DECODE (NVL (SUM (d.summa), 0),
                 0, 0,
                 (SUM (an.bonus_sum1) + SUM (an.bonus_sum2)) / SUM (d.summa))
       * 100
          zat
  FROM a13_ss8 d,
       a13_ss8_action_nakl an,
       user_list st,
       a13_ss8_tp_select tp
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