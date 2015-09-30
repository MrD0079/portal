/* Formatted on 15/07/2015 15:25:03 (QP5 v5.227.12220.39724) */
  SELECT uu.tn,
         uu.fio,
         uu.pos_name,
         uu.mt,
         uu.y,
         uu.my,
         TO_CHAR (uu.data, 'dd.mm.yyyy') data,
         t.lu,
         t.val,
         t.cur_id,
         cur.name valuta,
         p.val def_val,
         uu.cur_id def_cur_id,
         ok.ok_ndp,
         TO_CHAR (t.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         t.lu_fio,
         CASE
            WHEN (SELECT 1 - COUNT (*)
                    FROM free_staff
                   WHERE     tn = uu.tn
                         AND accepted = 1
                         AND datauvol > TRUNC (SYSDATE)) = 1
            THEN
               1
            ELSE
               0
         END
            enabled
    FROM (SELECT u.pos_id,
                 u.pos_name,
                 u.fio,
                 u.tn,
                 u.cur_id,
                 c.mt,
                 c.y,
                 c.data,
                 c.my
            FROM user_list u, calendar c
           WHERE     u.tn IN
                        (SELECT slave
                           FROM full
                          WHERE     master = :tn
                                AND (   (full = -2 AND :full = 'me')
                                     OR (full = 1 AND :full = 'slaves')
                                     OR (:full = 'all')))
                 AND c.data BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                AND TO_DATE (:ed, 'dd.mm.yyyy')
                 AND TRUNC (c.data, 'mm') = c.data
                 AND u.datauvol IS NULL
                 AND :dpt_id = u.dpt_id) uu,
         advance_tn t,
         currencies cur,
         advance_pos p,
         advance_ok ok
   WHERE     uu.tn = t.tn(+)
         AND uu.data = t.m(+)
         AND t.cur_id = cur.id(+)
         AND uu.pos_id = p.pos_id(+)
         AND :dpt_id = p.dpt_id(+)
         AND :dpt_id = ok.dpt_id(+)
         AND uu.data = ok.m(+)
ORDER BY uu.y, uu.my, uu.fio