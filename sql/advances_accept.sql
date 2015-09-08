/* Formatted on 01/09/2015 15:12:31 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
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
         AND t.m = TO_DATE (:sd, 'dd.mm.yyyy')
         AND u.datauvol IS NULL
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND c.data = t.m
         AND (u.pos_id = :pos_list OR :pos_list = 0)
         AND t.cur_id IN (:cur)
ORDER BY u.pos_name, u.fio