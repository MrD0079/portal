/* Formatted on 27/04/2016 18:04:44 (QP5 v5.252.13127.32867) */
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
                    tplist.tp_kod,
                    GREATEST (NVL (part1.sales, 0), NVL (part2.sales, 0)) sales,
                    NVL (part1.bonus, 0) + NVL (part2.bonus, 0) bonus,
                    NVL (part1.fio_db, part2.fio_db) fio_db,
                    NVL (part1.fio_ts, part2.fio_ts) fio_ts,
                    NVL (part1.ts_tab_num, part2.ts_tab_num) ts_tab_num,
                    NVL (part1.fio_eta, part2.fio_eta) fio_eta,
                    NVL (part1.h_fio_eta, part2.h_fio_eta) h_fio_eta,
                    NVL (part1.db_tn, part2.db_tn) db_tn
               FROM (SELECT d.tp_kod
                       FROM a16p5tp d, a16p5tp_select tp
                      WHERE d.tp_kod = tp.tp_kod
                     UNION
                     SELECT n.tp_kod
                       FROM a16p5net d,
                            a16p5net_select net,
                            a16p5n_nettp tp,
                            tp_nets n
                      WHERE     n.h_net = net.net_kod
                            AND n.tp_kod = tp.tp_kod(+)
                            AND n.tp_kod = n.tp_kod
                            AND d.net_name = n.net) tplist,
                    (SELECT m4.summa sales,
                            tp.bonus_sum1 bonus,
                            d.tp_kod,
                            fn_getname ( (SELECT parent
                                            FROM parents
                                           WHERE tn = st.tn))
                               fio_db,
                            st.fio fio_ts,
                            st.tab_num ts_tab_num,
                            m4.eta fio_eta,
                            m4.h_eta h_fio_eta,
                            (SELECT parent
                               FROM parents
                              WHERE tn = st.tn)
                               db_tn
                       FROM a16p5tp d,
                            user_list st,
                            a16p5tp_select tp,
                            a14mega m3,
                            a14mega m4
                      WHERE     m4.tab_num = st.tab_num
                            AND (   :exp_list_without_ts = 0
                                 OR st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master =
                                                        :exp_list_without_ts))
                            AND (   :exp_list_only_ts = 0
                                 OR st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_only_ts))
                            AND (   st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master =
                                                        DECODE ( :tn,
                                                                -1, master,
                                                                :tn))
                                 OR (SELECT NVL (is_traid, 0)
                                       FROM user_list
                                      WHERE tn = :tn) = 1)
                            AND st.dpt_id = :dpt_id and st.is_spd=1
                            AND d.tp_kod = tp.tp_kod
                            AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) =
                                   m4.h_eta
                            AND tp.bonus_dt1 IS NOT NULL
                            AND d.tp_kod = m3.tp_kod(+)
                            AND m3.dt(+) = TO_DATE ('01/03/2016', 'dd/mm/yyyy')
                            AND d.tp_kod = m4.tp_kod
                            AND m4.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy'))
                    part1,
                    (SELECT m4.summa sales,
                            tp.bonus_sum1 bonus,
                            n.tp_kod,
                            fn_getname ( (SELECT parent
                                            FROM parents
                                           WHERE tn = st.tn))
                               fio_db,
                            st.fio fio_ts,
                            st.tab_num ts_tab_num,
                            m4.eta fio_eta,
                            m4.h_eta h_fio_eta,
                            (SELECT parent
                               FROM parents
                              WHERE tn = st.tn)
                               db_tn
                       FROM a16p5net d,
                            user_list st,
                            a16p5net_select net,
                            a16p5n_nettp tp,
                            a14mega m3,
                            a14mega m4,
                            tp_nets n
                      WHERE     m4.tab_num = st.tab_num
                            AND (   :exp_list_without_ts = 0
                                 OR st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master =
                                                        :exp_list_without_ts))
                            AND (   :exp_list_only_ts = 0
                                 OR st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master = :exp_list_only_ts))
                            AND (   st.tn IN (SELECT slave
                                                FROM full
                                               WHERE master =
                                                        DECODE ( :tn,
                                                                -1, master,
                                                                :tn))
                                 OR (SELECT NVL (is_traid, 0)
                                       FROM user_list
                                      WHERE tn = :tn) = 1)
                            AND st.dpt_id = :dpt_id and st.is_spd=1
                            AND n.h_net = net.net_kod
                            AND tp.bonus_dt1 IS NOT NULL
                            AND n.tp_kod = tp.tp_kod(+)
                            AND n.tp_kod = m3.tp_kod(+)
                            AND DECODE ( :eta_list, '', m4.h_eta, :eta_list) =
                                   m4.h_eta
                            AND m3.dt(+) = TO_DATE ('01/03/2016', 'dd/mm/yyyy')
                            AND n.tp_kod = m4.tp_kod
                            AND m4.dt = TO_DATE ('01/04/2016', 'dd/mm/yyyy')
                            AND n.tp_kod = n.tp_kod
                            AND d.net_name = n.net) part2
              WHERE     tplist.tp_kod = part1.tp_kod(+)
                    AND tplist.tp_kod = part2.tp_kod(+)
                    AND NVL (part1.bonus, 0) + NVL (part2.bonus, 0) > 0)
   GROUP BY act,
            m,
            tp_kod,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn