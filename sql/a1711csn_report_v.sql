/* Formatted on 05.12.2017 16:27:56 (QP5 v5.252.13127.32867) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.net_kod), v.rec_count)
            rec_count,
         SUM (DECODE (v.ok_traid, NULL, x.bonus_sum1, v.sum_bonus)) sum_bonus,
         DECODE (v.ok_traid,
                 NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files),
                 v.sum_files)
            sum_files,
         fil_name,
         fil_kod fil
    FROM ACT_OK v,
         (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
              FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn AND act LIKE :act || '%' AND x1.m = :month
          GROUP BY p1.parent) f,
         user_list u,
         (SELECT d.net_kod,
                 fn_getname ( (SELECT parent
                                 FROM parents
                                WHERE tn = st.tn))
                    fio_db,
                 st.fio fio_ts,
                 st.tab_num ts_tab_num,
                 (SELECT parent
                    FROM parents
                   WHERE tn = st.tn)
                    parent_tn,
                 tp.bonus_sum1,
                 d.kod_filial fil_kod,
                 f.name fil_name
            FROM a1711csn d,
                 user_list st,
                 a1711csn_select tp,
                 bud_fil f,
                 act_ok a
           WHERE     d.tab_num = st.tab_num
                 AND st.dpt_id = :dpt_id
                 AND d.net_kod = tp.net_kod
                 AND tp.bonus_dt1 IS NOT NULL
                 AND d.kod_filial = f.sw_kod
                 AND a.m = :month
                 AND a.act = :act
                 AND a.tn = (SELECT parent
                               FROM parents
                              WHERE tn = st.tn)) x
   WHERE     x.parent_tn = v.tn(+)
         AND u.tn = x.parent_tn
         AND x.parent_tn = f.parent_tn(+)
         AND v.m(+) = :month
         AND v.act(+) = :act
         AND v.fil(+) = x.fil_kod
GROUP BY x.parent_tn,
         u.fio,
         v.ok_traid,
         v.ok_traid_lu,
         v.ok_traid_fio,
         v.rec_count,
         --v.sum_bonus,
         v.sum_files,
         f.sum_files,
         fil_name,
         fil_kod
ORDER BY db_fio, fil_name