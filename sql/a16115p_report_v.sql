/* Formatted on 16.11.2016 17:30:33 (QP5 v5.252.13127.32867) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.tp_kod), v.rec_count)
            rec_count,
         DECODE (v.ok_traid, NULL, SUM (x.bonus_sum1), v.sum_bonus) sum_bonus,
         DECODE (v.ok_traid,
                 NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files),
                 v.sum_files)
            sum_files
    FROM ACT_OK v,
         (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
              FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn AND act LIKE :act || '%' AND x1.m = :month
          GROUP BY p1.parent) f,
         user_list u,
         (SELECT tplist.tp_kod,
                 NVL (part1.fio_ts,                           /*part2.fio_ts*/
                                   0) ts_fio,
                 NVL (part1.bonus, 0)              /* + NVL (part2.bonus, 0)*/
                                     bonus_sum1,
                 NVL (part1.db_tn,                             /*part2.db_tn*/
                                  0) parent_tn
            FROM (SELECT d.tp_kod
                    FROM a16115p d, a16115p_select tp
                   WHERE d.tp_kod = tp.tp_kod /*UNION
                                              SELECT n.tp_kod
                                                FROM a16115pnet d,
                                                     a16115pnet_select net,
                                                     a16115pn_nettp tp,
                                                     tp_nets n
                                               WHERE     n.h_net = net.net_kod
                                                     AND n.tp_kod = tp.tp_kod(+)
                                                     AND n.tp_kod = n.tp_kod
                                                     AND d.net_name = n.net*/
                                             ) tplist,
                 (SELECT NVL (m4.summa, 0) + NVL (m4.coffee, 0) sales,
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
                    FROM a16115p d,
                         user_list st,
                         a16115p_select tp,
                         a14mega m3,
                         a14mega m4
                   WHERE     m4.tab_num = st.tab_num
                         AND st.dpt_id = :dpt_id
                         AND d.tp_kod = tp.tp_kod
                         AND tp.bonus_dt1 IS NOT NULL
                         AND d.tp_kod = m3.tp_kod(+)
                         AND m3.dt(+) = TO_DATE ('01/10/2016', 'dd/mm/yyyy')
                         AND d.tp_kod = m4.tp_kod
                         AND m4.dt = TO_DATE ('01/11/2016', 'dd/mm/yyyy'))
                 part1 /*,
                  (SELECT nvl(m4.summa,0)+nvl(m4.coffee,0) sales,
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
                     FROM a16115pnet d,
                          user_list st,
                          a16115pnet_select net,
                          a16115pn_nettp tp,
                          a14mega m3,
                          a14mega m4,
                          tp_nets n
                    WHERE     m4.tab_num = st.tab_num
                          AND st.dpt_id = :dpt_id
                          AND n.h_net = net.net_kod
                          AND tp.bonus_dt1 IS NOT NULL
                          AND n.tp_kod = tp.tp_kod(+)
                          AND n.tp_kod = m3.tp_kod(+)
                          AND m3.dt(+) = TO_DATE ('01/10/2016', 'dd/mm/yyyy')
                          AND n.tp_kod = m4.tp_kod
                          AND m4.dt = TO_DATE ('01/11/2016', 'dd/mm/yyyy')
                          AND n.tp_kod = n.tp_kod
                          AND d.net_name = n.net) part2*/
           WHERE tplist.tp_kod = part1.tp_kod(+) /*AND tplist.tp_kod = part2.tp_kod(+)*/
                                                AND NVL (part1.bonus, 0) /* + NVL (part2.bonus, 0)*/
                                                                        > 0)
         x
   WHERE     x.parent_tn = v.tn
         AND u.tn = x.parent_tn
         AND x.parent_tn = f.parent_tn(+)
         AND v.m = :month
         AND v.act = :act
         AND v.part1 = 1
/*AND v.part2 = 1*/
GROUP BY x.parent_tn,
         u.fio,
         v.ok_traid,
         v.ok_traid_lu,
         v.ok_traid_fio,
         v.rec_count,
         v.sum_bonus,
         v.sum_files,
         f.sum_files
ORDER BY db_fio