/* Formatted on 06.11.2014 13:10:29 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT d.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (CASE WHEN d.summny >= 500 THEN 1 END) condition_cnt,
       SUM (d.summny * 0.1) bonus_plan,
       SUM (an.bonus_sum1) bonus_fakt,
       SUM (d.summnakl) summnakl,
       SUM (d.summny) summny,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, an.bonus_sum1)) bonus_sum,
       SUM (DECODE (an.bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM (          (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)
)
          ok_chief,
         DECODE (NVL (SUM (d.summnakl), 0),
                 0, 0,
                 (SUM (an.bonus_sum1)) / SUM (d.summnakl))
       * 100
          zat
  FROM a14ny d,
       a14ny_action_nakl an,
       user_list st,
       a14ny_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_without_ts,
                                 0, master,
                                 :exp_list_without_ts))
       AND st.tn IN
              (SELECT slave
                 FROM full
                WHERE master =
                         DECODE (:exp_list_only_ts,
                                 0, master,
                                 :exp_list_only_ts))
       AND (   st.tn IN (SELECT slave
                           FROM full
                          WHERE master = DECODE (:tn, -1, master, :tn))
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND st.dpt_id = :dpt_id
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
       AND d.tp_kod = tp.tp_kod
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND TO_NUMBER (TO_CHAR (d.data, 'mm')) = :month
       AND tp.m= :month
       AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
              DECODE (:ok_bonus,
                      1, 0,
                      2, DECODE (an.bonus_dt1, NULL, 0, 1),
                      3, DECODE (an.bonus_dt1, NULL, 0, 1))
       AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
              DECODE (:is_act,
                      1, 0,
                      2, CASE WHEN d.summny >= 500 THEN 1 ELSE 0 END,
                      3, CASE WHEN d.summny >= 500 THEN 1 ELSE 0 END)