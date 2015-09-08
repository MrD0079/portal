/* Formatted on 03/04/2015 13:27:19 (QP5 v5.227.12220.39724) */
INSERT INTO act_svodt (act,
                       m,
                       sales,
                       bonus,
                       tp_kod,
                       fio_db,
                       fio_ts,
                       ts_tab_num,
                       fio_eta,
                       h_fio_eta,
                       db_tn,
                       dpt_id)
     SELECT act,
            m,
            SUM (sales) sales,
            SUM (bonus) bonus,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn,
            :dpt_id

       FROM (SELECT :act act,
                    :month m,
                    (NVL (d.sales, 0)) sales,
                    tp.bonus_sum1 bonus,
                    d.tp_kod,
                    fn_getname (
                                 (SELECT parent
                                    FROM parents
                                   WHERE tn = st.tn))
                       fio_db,
                    st.fio fio_ts,
                    st.tab_num ts_tab_num,
                    d.fio_eta,
                    d.h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = st.tn)
                       db_tn
               FROM a1503vs d, user_list st, a1503vs_tp_select tp
              WHERE     d.tab_num = st.tab_num
                    AND st.dpt_id = :dpt_id
                    AND d.tp_kod = tp.tp_kod
                    AND DECODE (:eta_list, '', d.h_fio_eta, :eta_list) =
                           d.h_fio_eta
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
                    AND (   st.tn IN
                               (SELECT slave
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
                    AND CASE
                           WHEN DECODE (NVL (d.plan_sales, 0),
                           0, 0,
                           (NVL (d.vk_weight, 0)) / d.plan_sales)
                 * 100 >= 100
                           THEN
                              1
                           ELSE
                              0
                        END = 1)
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn