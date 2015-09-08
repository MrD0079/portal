/* Formatted on 03.07.2015 12:16:40 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (rh.data, 'dd.mm.yyyy') dt,
         rh.*,
         fn_getname (rh.tn) fio,
         rp.name pos,
         c.mt || ' ' || c.y period
    FROM routes_head rh, routes_pos rp, calendar c
   WHERE     TRUNC (rh.data, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd/mm/yyyy'),
                                                  'mm')
                                       AND TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'),
                                                  'mm')
         AND (   tn IN (SELECT emp_tn
                          FROM who_full
                         WHERE exp_tn = :tn)
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND rh.pos_otv = rp.id(+)
         AND rh.data = c.data
ORDER BY fio,
         rh.num,
         rh.data,
         pos