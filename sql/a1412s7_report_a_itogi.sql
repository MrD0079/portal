/* Formatted on 28/01/2015 9:45:51 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT d.H_TP_KOD_DATA_NAKL) cnt_nakl,
       COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (
          CASE
             WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1
             ELSE 0
          END)
          condition_cnt,
       --SUM (d.summny * 0.1) bonus_plan,
       SUM (an.bonus_sum1) bonus_fakt,
       SUM (d.summnds) summnds,
       --SUM (d.summny) summny,
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
         DECODE (NVL (SUM (d.summnds), 0),
                 0, 0,
                 (SUM (an.bonus_sum1)) / SUM (d.summnds))
       * 100
          zat
  FROM a1412s7 d,
       a1412s7_action_nakl an,
       user_list st,
       a1412s7_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.dpt_id = :dpt_id
       AND d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
       AND d.tp_kod = tp.tp_kod
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
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
       AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
              DECODE (:ok_bonus,
                      1, 0,
                      2, DECODE (an.bonus_dt1, NULL, 0, 1),
                      3, DECODE (an.bonus_dt1, NULL, 0, 1))
       AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
              DECODE (
                 :is_act,
                 1, 0,
                 2, CASE
                       WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1
                       ELSE 0
                    END,
                 3, CASE
                       WHEN d.TRUF + d.SHARM + d.TRUFE + d.OTHER >= 7 THEN 1
                       ELSE 0
                    END)