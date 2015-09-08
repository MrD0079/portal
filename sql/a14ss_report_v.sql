/* Formatted on 09/12/2014 20:50:00 (QP5 v5.227.12220.39724) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.tp_kod), v.rec_count)
            rec_count,
         DECODE (v.ok_traid,
                 NULL, SUM (DECODE (x.bonus_dt1, NULL, NULL, x.bonus_sum1)),
                 v.sum_bonus)
            sum_bonus,
         DECODE (v.ok_traid,
                 NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files),
                 v.sum_files)
            sum_files
    FROM ACT_OK v,
                  (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
              FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn AND x1.m = :month and act=:act
          GROUP BY p1.parent) f,

         user_list u,
         (SELECT tp.*,
                 st.fio ts_fio,
                          (SELECT DECODE (lu, NULL, 0, 1)
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

                    ok_chief,
                 TO_CHAR (
                    CASE
                       WHEN :month = 10 THEN tp.bonus_dt10
                       WHEN :month = 11 THEN tp.bonus_dt11
                       WHEN :month = 12 THEN tp.bonus_dt12
                    END,
                    'dd.mm.yyyy')
                    bonus_dt1,
                 CASE
                    WHEN :month = 10 THEN tp.bonus_sum10
                    WHEN :month = 11 THEN tp.bonus_sum11
                    WHEN :month = 12 THEN tp.bonus_sum12
                 END
                    bonus_sum1,
                 fn_getname (
                              (SELECT parent
                                 FROM parents
                                WHERE tn = st.tn))
                    parent_fio,
                 (SELECT parent
                    FROM parents
                   WHERE tn = st.tn)
                    parent_tn,
                          (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
            FROM ACT_OK
           WHERE     tn = (SELECT parent
                             FROM parents
                            WHERE tn = st.tn)
                 AND m = :month and act=:act)

                    ok_chief_date
            FROM a14ss d, user_list st, a14ss_tp_select tp
           WHERE     d.tab_num = st.tab_num
                 AND st.dpt_id = :dpt_id
                 AND d.tp_kod = tp.tp_kod) x
   WHERE     x.parent_tn = v.tn
         AND u.tn = x.parent_tn
         AND x.parent_tn = f.parent_tn(+)
                  AND v.m = :month
         and v.act=:act
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