/* Formatted on 13/03/2015 9:51:18 (QP5 v5.227.12220.39724) */
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
                    mar_apr sales,
                    bonus_sum bonus,
                    tp_kod,
                    fn_getname (
                                 (SELECT parent
                                    FROM parents
                                   WHERE tn = ts_tn))
                       fio_db,
                    ts_fio fio_ts,
                    ts_tab_num ts_tab_num,
                    fio_eta,
                    h_fio_eta,
                    (SELECT parent
                       FROM parents
                      WHERE tn = ts_tn)
                       db_tn
               FROM (SELECT z.*,
                            NVL (
                               CASE
                                  WHEN     jan_feb > 3000
                                       AND jan_feb <= 5000
                                       AND delta >= 2000
                                  THEN
                                     1
                                  WHEN     jan_feb > 5000
                                       AND jan_feb <= 7000
                                       AND delta >= 3000
                                  THEN
                                     1
                                  WHEN     jan_feb > 6000
                                       AND jan_feb <= 10000
                                       AND delta >= 5000
                                  THEN
                                     1
                                  WHEN     jan_feb > 10000
                                       AND jan_feb <= 15000
                                       AND delta >= 7000
                                  THEN
                                     1
                                  WHEN     jan_feb > 15000
                                       AND jan_feb <= 20000
                                       AND delta >= 10000
                                  THEN
                                     1
                                  WHEN     jan_feb > 20000
                                       AND jan_feb <= 30000
                                       AND delta >= 15000
                                  THEN
                                     1
                                  WHEN jan_feb > 30000 AND delta >= 20000
                                  THEN
                                     1
                               END,
                               0)
                               is_act,
                            NVL (
                               CASE
                                  WHEN     jan_feb > 3000
                                       AND jan_feb <= 5000
                                       AND delta >= 2000
                                  THEN
                                     CASE
                                        WHEN delta >= 2000 AND delta < 3000
                                        THEN
                                           240
                                        WHEN delta >= 3000 AND delta < 5000
                                        THEN
                                           360
                                        WHEN delta > 5000
                                        THEN
                                           600
                                     END
                                  WHEN     jan_feb > 5000
                                       AND jan_feb <= 7000
                                       AND delta >= 3000
                                  THEN
                                     CASE
                                        WHEN delta >= 3000 AND delta < 5000
                                        THEN
                                           360
                                        WHEN delta >= 5000 AND delta < 7000
                                        THEN
                                           600
                                        WHEN delta > 7000
                                        THEN
                                           840
                                     END
                                  WHEN     jan_feb > 6000
                                       AND jan_feb <= 10000
                                       AND delta >= 5000
                                  THEN
                                     CASE
                                        WHEN delta >= 5000 AND delta < 7000
                                        THEN
                                           600
                                        WHEN delta >= 7000 AND delta < 10000
                                        THEN
                                           840
                                        WHEN delta > 10000
                                        THEN
                                           1200
                                     END
                                  WHEN     jan_feb > 10000
                                       AND jan_feb <= 15000
                                       AND delta >= 7000
                                  THEN
                                     CASE
                                        WHEN delta >= 7000 AND delta < 10000
                                        THEN
                                           840
                                        WHEN delta >= 10000 AND delta < 15000
                                        THEN
                                           1200
                                        WHEN delta > 15000
                                        THEN
                                           1800
                                     END
                                  WHEN     jan_feb > 15000
                                       AND jan_feb <= 20000
                                       AND delta >= 10000
                                  THEN
                                     CASE
                                        WHEN delta >= 10000 AND delta < 15000
                                        THEN
                                           1200
                                        WHEN delta >= 15000 AND delta < 20000
                                        THEN
                                           1800
                                        WHEN delta > 20000
                                        THEN
                                           2400
                                     END
                                  WHEN     jan_feb > 20000
                                       AND jan_feb <= 30000
                                       AND delta >= 15000
                                  THEN
                                     CASE
                                        WHEN delta >= 15000 AND delta < 20000
                                        THEN
                                           1800
                                        WHEN delta > 20000
                                        THEN
                                           2400
                                     END
                                  WHEN jan_feb > 30000 AND delta >= 20000
                                  THEN
                                     CASE WHEN delta > 20000 THEN 2400 END
                               END,
                               0)
                               max_bonus
                       FROM (SELECT d.h_fio_eta,
                                    d.fio_eta,
                                    d.tp_kod,
                                    d.tp_ur,
                                    d.tp_addr,
                                    d.jan_feb,
                                      NVL (d.mar_apr, 0)
                                    - NVL (cp.summa, 0)
                                    - NVL (oy.summa, 0)
                                    - NVL (vc.summa, 0)
                                    - NVL (oy4.summa, 0)
                                       mar_apr,
                                      NVL (d.mar_apr, 0)
                                    - NVL (cp.summa, 0)
                                    - NVL (oy.summa, 0)
                                    - NVL (vc.summa, 0)
                                    - NVL (oy4.summa, 0)
                                    - NVL (d.jan_feb, 0)
                                       delta,
                                    tp.bonus_sum,
                                    (SELECT parent
                                       FROM parents
                                      WHERE tn = st.tn)
                                       parent_tn,
                                    st.fio ts_fio,
                                    st.tn ts_tn,
                                    st.tab_num ts_tab_num
                               FROM a1404bum d,
                                    user_list st,
                                    a1404bum_tp_select tp,
                                    (  SELECT t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta,
                                              SUM (summa) summa
                                         FROM user_list st,
                                              a1403cp t1,
                                              a1403cp_action_nakl t2,
                                              a1403cp_tp_select t3
                                        WHERE     st.tab_num = t1.tab_num
                                              AND t3.tp_kod = t1.tp_kod
                                              AND t2.H_TP_KOD_DATA_NAKL =
                                                     t1.H_TP_KOD_DATA_NAKL
                                              AND t2.if1 = 1
                                              AND t1.data BETWEEN TO_DATE (
                                                                     '01.03.2014',
                                                                     'dd.mm.yyyy')
                                                              AND TO_DATE (
                                                                     '30.04.2014',
                                                                     'dd.mm.yyyy')
                                              AND st.dpt_id = :dpt_id
                                     GROUP BY t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta) cp,
                                    (  SELECT t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta,
                                              SUM (summa) summa
                                         FROM user_list st,
                                              a1403oy t1,
                                              a1403oy_action_nakl t2,
                                              a1403oy_tp_select t3
                                        WHERE     st.tab_num = t1.tab_num
                                              AND t3.tp_kod = t1.tp_kod
                                              AND t2.H_TP_KOD_DATA_NAKL =
                                                     t1.H_TP_KOD_DATA_NAKL
                                              AND t2.if1 = 1
                                              AND t1.data BETWEEN TO_DATE (
                                                                     '01.03.2014',
                                                                     'dd.mm.yyyy')
                                                              AND TO_DATE (
                                                                     '30.04.2014',
                                                                     'dd.mm.yyyy')
                                              AND st.dpt_id = :dpt_id
                                     GROUP BY t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta) oy,
                                    (  SELECT t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta,
                                              SUM (summa) summa
                                         FROM user_list st,
                                              a1403vc t1,
                                              a1403vc_action_nakl t2,
                                              a1403vc_tp_select t3
                                        WHERE     st.tab_num = t1.tab_num
                                              AND t3.tp_kod = t1.tp_kod
                                              AND t2.H_TP_KOD_DATA_NAKL =
                                                     t1.H_TP_KOD_DATA_NAKL
                                              AND t2.if1 = 1
                                              AND t1.data BETWEEN TO_DATE (
                                                                     '01.03.2014',
                                                                     'dd.mm.yyyy')
                                                              AND TO_DATE (
                                                                     '30.04.2014',
                                                                     'dd.mm.yyyy')
                                              AND st.dpt_id = :dpt_id
                                     GROUP BY t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta) vc,
                                    (  SELECT t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta,
                                              SUM (summa) summa
                                         FROM user_list st,
                                              a1404oy t1,
                                              a1404oy_action_nakl t2,
                                              a1404oy_tp_select t3
                                        WHERE     st.tab_num = t1.tab_num
                                              AND t3.tp_kod = t1.tp_kod
                                              AND t2.H_TP_KOD_DATA_NAKL =
                                                     t1.H_TP_KOD_DATA_NAKL
                                              AND t2.if1 = 1
                                              AND t1.data BETWEEN TO_DATE (
                                                                     '01.03.2014',
                                                                     'dd.mm.yyyy')
                                                              AND TO_DATE (
                                                                     '30.04.2014',
                                                                     'dd.mm.yyyy')
                                              AND st.dpt_id = :dpt_id
                                     GROUP BY t1.tp_kod,
                                              t1.tab_num,
                                              t1.h_fio_eta) oy4
                              WHERE     d.tab_num = st.tab_num
                                    AND st.tn IN
                                           (SELECT slave
                                              FROM full
                                             WHERE master =
                                                      DECODE (
                                                         :exp_list_without_ts,
                                                         0, master,
                                                         :exp_list_without_ts))
                                    AND st.tn IN
                                           (SELECT slave
                                              FROM full
                                             WHERE master =
                                                      DECODE (
                                                         :exp_list_only_ts,
                                                         0, master,
                                                         :exp_list_only_ts))
                                    AND (   st.tn IN
                                               (SELECT slave
                                                  FROM full
                                                 WHERE master =
                                                          DECODE (:tn,
                                                                  -1, master,
                                                                  :tn))
                                         OR (SELECT NVL (is_traid, 0)
                                               FROM user_list
                                              WHERE tn = :tn) = 1)
                                    AND st.dpt_id = :dpt_id
                                    AND d.tp_kod = tp.tp_kod
                                    AND DECODE (:eta_list,
                                                '', d.h_fio_eta,
                                                :eta_list) = d.h_fio_eta
                                    AND DECODE (:ok_bonus,  1, 0,  2, 1,  3, 0) =
                                           DECODE (
                                              :ok_bonus,
                                              1, 0,
                                              2, DECODE (tp.bonus_dt,
                                                         NULL, 0,
                                                         1),
                                              3, DECODE (tp.bonus_dt,
                                                         NULL, 0,
                                                         1))
                                    AND d.tp_kod = cp.tp_kod(+)
                                    AND d.tab_num = cp.tab_num(+)
                                    AND d.h_fio_eta = cp.h_fio_eta(+)
                                    AND d.tp_kod = oy.tp_kod(+)
                                    AND d.tab_num = oy.tab_num(+)
                                    AND d.h_fio_eta = oy.h_fio_eta(+)
                                    AND d.tp_kod = vc.tp_kod(+)
                                    AND d.tab_num = vc.tab_num(+)
                                    AND d.h_fio_eta = vc.h_fio_eta(+)
                                    AND d.tp_kod = oy4.tp_kod(+)
                                    AND d.tab_num = oy4.tab_num(+)
                                    AND d.h_fio_eta = oy4.h_fio_eta(+)) z) z1
              WHERE is_act = 1)
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn