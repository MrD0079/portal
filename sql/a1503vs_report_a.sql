/* Formatted on 03/04/2015 13:26:33 (QP5 v5.227.12220.39724) */
  SELECT d.fio_eta,
         d.tp_kod,
         d.tp_ur,
         d.plan_sales,
         d.vk_weight,
         (NVL (d.sales, 0)) sales,
         round((NVL (d.sales, 0)) * 0.05,2) max_bonus,
         d.tp_addr,
         DECODE (NVL (d.plan_sales, 0),
                           0, 0,
                           (NVL (d.vk_weight, 0)) / d.plan_sales)
                 * 100
            rost_perc,
         CASE
            WHEN DECODE (NVL (d.plan_sales, 0),
                           0, 0,
                           (NVL (d.vk_weight, 0)) / d.plan_sales)
                 * 100 >= 100
            THEN
               1
            ELSE
               0
         END
            if1,
         tp.bonus_sum1,
         TO_CHAR (tp.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
         (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE tn = (SELECT parent
                         FROM parents
                        WHERE tn = st.tn)AND m = :month and act=:act)
            ok_chief_date,
         (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE tn = (SELECT parent
                         FROM parents
                        WHERE tn = st.tn)AND m = :month and act=:act)
            ok_chief,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.fio ts_fio,
         st.tn ts_tn
    FROM a1503vs d, user_list st, a1503vs_tp_select tp
   WHERE     d.tab_num = st.tab_num
         AND st.dpt_id = :dpt_id and st.is_spd=1
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
                         WHEN DECODE (NVL (d.plan_sales, 0),
                           0, 0,
                           (NVL (d.vk_weight, 0)) / d.plan_sales)
                 * 100 >= 100
                         THEN
                            1
                         ELSE
                            0
                      END,
                   3, CASE
                         WHEN DECODE (NVL (d.plan_sales, 0),
                           0, 0,
                           (NVL (d.vk_weight, 0)) / d.plan_sales)
                 * 100 >= 100
                         THEN
                            1
                         ELSE
                            0
                      END)
ORDER BY parent_fio, ts_fio, fio_eta