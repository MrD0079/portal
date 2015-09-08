/* Formatted on 26/05/2015 17:44:08 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c, SUM (val) val
  FROM (


/* Formatted on 27/05/2015 13:27:57 (QP5 v5.227.12220.39724) */
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
         ok.ok_ndp
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
                                     OR (full = 1 AND :full = 'slaves')))
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



)
