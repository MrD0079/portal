/* Formatted on 29.07.2013 16:27:50 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT an.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (d.summa) summa,
       SUM (an.ok_chief) ok_chief,
       SUM (NVL (an.if1, 0)) + SUM (NVL (an.if2, 0)) + SUM (NVL (an.if3, 0))
          bonus_sum,
         (  SUM (NVL (an.if1, 0))
          + SUM (NVL (an.if2, 0))
          + SUM (NVL (an.if3, 0)))
       * 8.9
          bonus_sum_price,
       COUNT (
          DISTINCT DECODE (an.bonus_dt, NULL, NULL, an.H_TP_KOD_DATA_NAKL))
          bonus_cnt,
       AVG (
          (SELECT SUM (bonus) bonus
             FROM a13_sp8_files f, user_list st
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
         DECODE (
            NVL (SUM (d.summa), 0),
            0, 0,
              (  (  SUM (NVL (an.if1, 0))
                  + SUM (NVL (an.if2, 0))
                  + SUM (NVL (an.if3, 0)))
               * 8.9)
            / SUM (d.summa))
       * 100
          zat
  FROM a13_sp8 d,
       a13_sp8_action_nakl an,
       user_list st,
       a13_sp8_tp_select tp
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