/* Formatted on 19.08.2017 12:53:44 (QP5 v5.252.13127.32867) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.tp_kod), v.rec_count) rec_count,
         DECODE (v.ok_traid, NULL, SUM (x.bonus_sum1), v.sum_bonus) sum_bonus,
         DECODE (v.ok_traid, NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files), v.sum_files) sum_files
    FROM ACT_OK v,
         (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
              FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn AND act LIKE :act || '%' AND x1.m = :month
          GROUP BY p1.parent) f,
         user_list u,
         (SELECT tplist.tp_kod,
                 NVL (part1.fio_ts, 0) ts_fio,
                 NVL (part1.bonus, 0) bonus_sum1,
                 NVL (part1.db_tn, 0) parent_tn
            FROM (SELECT d.tp_kod
                    FROM a1712nyo2 d, a1712nyo2_select tp
                   WHERE d.tp_kod = tp.tp_kod) tplist,
                 (SELECT NVL (d.fact, 0) sales,
                         tp.bonus_sum1 bonus,
                         d.tp_kod,
                         fn_getname ( (SELECT parent
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
                    FROM a1712nyo2 d, user_list st, a1712nyo2_select tp
                   WHERE d.tab_num = st.tab_num AND st.dpt_id = :dpt_id AND d.tp_kod = tp.tp_kod AND tp.bonus_dt1 IS NOT NULL) part1
           WHERE tplist.tp_kod = part1.tp_kod(+) AND NVL (part1.bonus, 0) > 0) x
   WHERE x.parent_tn = v.tn AND u.tn = x.parent_tn AND x.parent_tn = f.parent_tn(+) AND v.m = :month AND v.act = :act AND v.part1 = 1
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