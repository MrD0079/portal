/* Formatted on 03/04/2015 13:24:07 (QP5 v5.227.12220.39724) */
SELECT COUNT (DISTINCT tp.tp_kod) cnt_tp,
       SUM (
          CASE
             WHEN CASE
                     WHEN     DECODE (NVL (d.plan_sales, 0),
                                      0, 0,
                                      (NVL (d.plan_sales, 0)) / d.vk_weight)
                            * 100 < 0
                     THEN
                        0
                     ELSE
                            DECODE (NVL (d.plan_sales, 0),
                                    0, 0,
                                    (NVL (d.plan_sales, 0)) / d.vk_weight)
                          * 100
                  END >= 100
             THEN
                1
             ELSE
                0
          END)
          condition_cnt,
       SUM (tp.bonus_sum1) bonus_fakt,
       SUM (d.sales * 0.05) bonus_plan,
       SUM (d.plan_sales) plan_sales,
       SUM (d.sales) sales,
       SUM (DECODE (tp.bonus_dt1, NULL, NULL, tp.bonus_sum1)) bonus_sum,
       SUM (DECODE (tp.bonus_dt1, NULL, NULL, 1)) bonus_dt_cnt,
       SUM ( (SELECT DECODE (lu, NULL, 0, 1)
                FROM ACT_OK
               WHERE tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act))
          ok_chief,
         DECODE (NVL (SUM (d.sales), 0),
                 0, 0,
                 (SUM (tp.bonus_sum1)) / SUM (d.sales))
       * 100
          zat
  FROM a1503vs d, user_list st, a1503vs_tp_select tp
 WHERE     d.tab_num = st.tab_num
       AND st.dpt_id = :dpt_id
       AND d.tp_kod = tp.tp_kod
       AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) = d.h_fio_eta
       AND (   :exp_list_without_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
                      OR st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
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
                                           NVL (d.plan_sales, 0),
                                           0, 0,
                                           (NVL (d.plan_sales, 0)) / d.vk_weight)
                                      * 100 < 0
                               THEN
                                  0
                               ELSE
                                      DECODE (
                                         NVL (d.plan_sales, 0),
                                         0, 0,
                                         (NVL (d.plan_sales, 0)) / d.vk_weight)
                                    * 100
                            END >= 100
                       THEN
                          1
                       ELSE
                          0
                    END,
                 3, CASE
                       WHEN CASE
                               WHEN     DECODE (
                                           NVL (d.plan_sales, 0),
                                           0, 0,
                                           (NVL (d.plan_sales, 0)) / d.vk_weight)
                                      * 100 < 0
                               THEN
                                  0
                               ELSE
                                      DECODE (
                                         NVL (d.plan_sales, 0),
                                         0, 0,
                                         (NVL (d.plan_sales, 0)) / d.vk_weight)
                                    * 100
                            END >= 100
                       THEN
                          1
                       ELSE
                          0
                    END)