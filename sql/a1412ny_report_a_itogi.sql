/* Formatted on 26/12/2014 15:53:50 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (
          CASE
             WHEN CASE
                     WHEN     DECODE (
                                 NVL (d.sales_nov, 0),
                                 0, 0,
                                   (  NVL (d.sales_dec, 0)
                                    - NVL (z.sales, 0)
                                    - NVL (s7.sales, 0))
                                 / d.sales_nov)
                            * 100
                          - 100 < 0
                     THEN
                        0
                     ELSE
                            DECODE (
                               NVL (d.sales_nov, 0),
                               0, 0,
                                 (  NVL (d.sales_dec, 0)
                                  - NVL (z.sales, 0)
                                  - NVL (s7.sales, 0))
                               / d.sales_nov)
                          * 100
                        - 100
                  END >= 40
             THEN
                1
             ELSE
                0
          END)
          condition_cnt,
       SUM (tp.bonus_sum1) bonus_fakt,
       SUM ( (d.sales_dec - NVL (z.sales, 0) - NVL (s7.sales, 0)) * 0.05)
          bonus_plan,
       SUM (d.sales_nov) sales_nov,
       SUM ( (d.sales_dec - NVL (z.sales, 0) - NVL (s7.sales, 0))) sales_dec,
       SUM (DECODE (tp.bonus_dt1, NULL, NULL, tp.bonus_sum1)) bonus_sum,
       SUM (DECODE (tp.bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM ( (SELECT DECODE (lu, NULL, 0, 1)
                FROM ACT_OK
               WHERE tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)))
          ok_chief,
         DECODE (
            NVL (SUM ( (d.sales_dec - NVL (z.sales, 0) - NVL (s7.sales, 0))),
                 0),
            0, 0,
              (SUM (tp.bonus_sum1))
            / SUM ( (d.sales_dec - NVL (z.sales, 0) - NVL (s7.sales, 0))))
       * 100
          zat
  FROM a1412ny d,
       user_list st,
       a1412ny_tp_select tp,
       (  SELECT d.tp_kod_key, SUM (d.sales) sales
            FROM a1411z d, a1411z_action_nakl an, a1411z_tp_select tp
           WHERE     d.H_TP_KOD_key_DATA_NAKL = an.H_TP_KOD_key_DATA_NAKL
                 AND d.tp_kod_key = tp.tp_kod_key
                 AND TRUNC (d.data, 'mm') =
                        TO_DATE ('01.12.2014', 'dd.mm.yyyy')
        GROUP BY d.tp_kod_key) z,
       (  SELECT d.tp_kod, SUM (d.summnds) sales
            FROM a1412s7 d, a1412s7_action_nakl an, a1412s7_tp_select tp
           WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                 AND d.tp_kod = tp.tp_kod
                 AND TRUNC (d.data, 'mm') =
                        TO_DATE ('01.12.2014', 'dd.mm.yyyy')
        GROUP BY d.tp_kod) s7
 WHERE     d.tab_num = st.tab_num
       AND st.dpt_id = :dpt_id
       AND d.tp_kod = tp.tp_kod
       AND d.tp_kod = z.tp_kod_key(+)
       AND d.tp_kod = s7.tp_kod(+)
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
                      2, DECODE (tp.bonus_dt1, NULL, 0, 1),
                      3, DECODE (tp.bonus_dt1, NULL, 0, 1))
       AND DECODE (:is_act,  1, 0,  2, 1,  3, 0) =
              DECODE (
                 :is_act,
                 1, 0,
                 2, CASE
                       WHEN CASE
                               WHEN     DECODE (
                                           NVL (d.sales_nov, 0),
                                           0, 0,
                                             (  NVL (d.sales_dec, 0)
                                              - NVL (z.sales, 0)
                                              - NVL (s7.sales, 0))
                                           / d.sales_nov)
                                      * 100
                                    - 100 < 0
                               THEN
                                  0
                               ELSE
                                      DECODE (
                                         NVL (d.sales_nov, 0),
                                         0, 0,
                                           (  NVL (d.sales_dec, 0)
                                            - NVL (z.sales, 0)
                                            - NVL (s7.sales, 0))
                                         / d.sales_nov)
                                    * 100
                                  - 100
                            END >= 40
                       THEN
                          1
                       ELSE
                          0
                    END,
                 3, CASE
                       WHEN CASE
                               WHEN     DECODE (
                                           NVL (d.sales_nov, 0),
                                           0, 0,
                                             (  NVL (d.sales_dec, 0)
                                              - NVL (z.sales, 0)
                                              - NVL (s7.sales, 0))
                                           / d.sales_nov)
                                      * 100
                                    - 100 < 0
                               THEN
                                  0
                               ELSE
                                      DECODE (
                                         NVL (d.sales_nov, 0),
                                         0, 0,
                                           (  NVL (d.sales_dec, 0)
                                            - NVL (z.sales, 0)
                                            - NVL (s7.sales, 0))
                                         / d.sales_nov)
                                    * 100
                                  - 100
                            END >= 40
                       THEN
                          1
                       ELSE
                          0
                    END)