/* Formatted on 27/04/2016 18:04:11 (QP5 v5.252.13127.32867) */
INSERT INTO act_svod (act,
                      m,
                      sales,
                      bonus,
                      tp,
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
            COUNT (DISTINCT tp_kod) tp,
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
                    GREATEST (NVL (part1.sales, 0), 0) sales,
                    NVL (part1.bonus, 0) bonus,
                    NVL (part1.fio_db, 0) fio_db,
                    NVL (part1.fio_ts, 0) fio_ts,
                    NVL (part1.ts_tab_num, 0) ts_tab_num,
                    NVL (part1.fio_eta, 0) fio_eta,
                    NVL (part1.h_fio_eta, 0) h_fio_eta,
                    NVL (part1.db_tn, 0) db_tn
               FROM (SELECT d.tp_kod
                       FROM a1610s6 d, a1610s6_select tp
                      WHERE d.tp_kod = tp.tp_kod
                     ) tplist,
                    (SELECT nvl(m4.summa,0)+nvl(m4.coffee,0) sales,
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
                       FROM a1610s6 d,
                            user_list st,
                            a1610s6_select tp,
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
                            AND m3.dt(+) = TO_DATE ('01/09/2016', 'dd/mm/yyyy')
                            AND d.tp_kod = m4.tp_kod
                            AND m4.dt = TO_DATE ('01/10/2016', 'dd/mm/yyyy'))
                    part1
              WHERE     tplist.tp_kod = part1.tp_kod(+)
                    
                    AND NVL (part1.bonus, 0) > 0)
   GROUP BY act,
            m,
            fio_db,
            fio_ts,
            ts_tab_num,
            fio_eta,
            h_fio_eta,
            db_tn