/* Formatted on 1/4/2016 5:03:54  (QP5 v5.252.13127.32867) */
  SELECT x.parent_tn db_tn,
         u.fio db_fio,
         v.ok_traid,
         TO_CHAR (v.ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
         v.ok_traid_fio,
         DECODE (v.ok_traid, NULL, COUNT (DISTINCT x.h_client), v.rec_count)
            rec_count,
         DECODE (v.ok_traid,
                 NULL, SUM (DECODE (x.bonus_dt1, NULL, NULL, x.bonus_sum1)),
                 v.sum_bonus)
            sum_bonus,
         DECODE (v.ok_traid,
                 NULL, DECODE (f.sum_files, NULL, NULL, f.sum_files),
                 v.sum_files)
            sum_files,
         x.fil,
         x.fil_name
    FROM ACT_OK v,
         (  SELECT p1.parent parent_tn, SUM (bonus) sum_files
              FROM ACT_FILES x1, parents p1
             WHERE x1.tn = p1.tn AND act = :act AND x1.m = :month
          GROUP BY p1.parent) f,
         user_list u,
         (  SELECT wm_concat (DISTINCT (SELECT parent
                                          FROM parents
                                         WHERE tn = st.tn))
                      parent_tn,
                   wm_concat (DISTINCT fn_getname ( (SELECT parent
                                                       FROM parents
                                                      WHERE tn = st.tn)))
                      parent_fio,
                   wm_concat (DISTINCT st.fio) ts_fio,
                   sp.client,
                   sp.h_client,
                   DECODE (an.id, NULL, 0, 1) selected,
                   an.bonus_sum1,
                   TO_CHAR (an.bonus_dt1, 'dd.mm.yyyy') bonus_dt1,
                   wm_concat (
                      DISTINCT (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
                                  FROM ACT_OK
                                 WHERE     tn = (SELECT parent
                                                   FROM parents
                                                  WHERE tn = st.tn)
                                       AND m = :month
                                       AND act = :act and fil=an.fil))
                      ok_chief_date,
                   wm_concat (DISTINCT (SELECT DECODE (lu, NULL, 0, 1)
                                          FROM ACT_OK
                                         WHERE     tn = (SELECT parent
                                                           FROM parents
                                                          WHERE tn = st.tn)
                                               AND m = :month
                                               AND act = :act and fil=an.fil))
                      ok_chief,
                   COUNT (*) c,
                   sp.plan * 1000 plan,
                   sp.bonus,
                   SUM (d.act_summ) sales,
                   f.id fil,
                   f.name fil_name
              FROM A1512T_XLS_SALESPLAN sp,
                   A1512T_XLS_TPCLIENT tp,
                   a1512t d,
                   A1512t_ACTION_CLIENT an,
                   user_list st,
                   bud_fil f
             WHERE     d.tab_num = st.tab_num
                   AND st.dpt_id = :dpt_id
                   AND tp.tp_kod = d.tp_kod
                   AND sp.H_client = tp.H_client
                   AND sp.H_client = an.H_client(+)
                   AND an.fil = f.id
          GROUP BY sp.client,
                   sp.h_client,
                   an.id,
                   an.bonus_sum1,
                   an.bonus_dt1,
                   sp.plan,
                   sp.bonus,
                   f.id,
                   f.name) x
   WHERE     x.parent_tn = v.tn
         AND u.tn = x.parent_tn
         AND x.parent_tn = f.parent_tn(+)
         AND v.m = :month
         AND v.act = :act
         AND v.fil = x.fil
GROUP BY x.parent_tn,
         u.fio,
         v.ok_traid,
         v.ok_traid_lu,
         v.ok_traid_fio,
         v.rec_count,
         v.sum_bonus,
         v.sum_files,
         f.sum_files,
         x.fil,
         x.fil_name
ORDER BY db_fio