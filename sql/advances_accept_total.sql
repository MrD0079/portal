/* Formatted on 05/04/2016 19:45:36 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c, SUM (val) val
  FROM (  SELECT u.tn,
                 u.fio,
                 u.pos_id,
                 u.pos_name,
                 u.tab_num,
                 c.mt,
                 c.y,
                 c.my,
                 TO_CHAR (t.m, 'dd.mm.yyyy') data,
                 t.lu,
                 t.val,
                 t.cur_id,
                 cur.name valuta,
                 p.val def_val,
                 u.cur_id def_cur_id,
                 TO_CHAR (t.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                 t.lu_fio,
                 CASE WHEN f.id IS NOT NULL THEN 1 END free_staff_flag
            FROM user_list u,
                 advance_tn t,
                 currencies cur,
                 advance_pos p,
                 calendar c,
                 free_staff f
           WHERE     u.tn = t.tn(+)
                 AND u.tn = f.tn(+)
                 AND t.cur_id = cur.id(+)
                 AND u.pos_id = p.pos_id(+)
                 AND :dpt_id = u.dpt_id
                 AND :dpt_id = p.dpt_id(+)
                 AND t.m = TO_DATE ( :sd, 'dd.mm.yyyy')
                 AND u.datauvol IS NULL
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_without_ts))
                 AND c.data = t.m
                 AND (u.pos_id = :pos_list OR :pos_list = 0)
                 AND t.cur_id IN ( :cur)
                 AND (   (    t.val <> 0
                          AND NVL (
                                 (SELECT k.ok_ndp
                                    FROM advance_ok k
                                   WHERE     k.m = TO_DATE ( :sd, 'dd.mm.yyyy')
                                         AND dpt_id = :dpt_id),
                                 0) = 1)
                      OR NVL (
                            (SELECT k.ok_ndp
                               FROM advance_ok k
                              WHERE     k.m = TO_DATE ( :sd, 'dd.mm.yyyy')
                                    AND dpt_id = :dpt_id),
                            0) = 0)
                 AND NVL (u.is_top, 0) = 0
        ORDER BY u.pos_name, u.fio)