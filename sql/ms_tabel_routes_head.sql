/* Formatted on 01/07/2015 17:27:11 (QP5 v5.227.12220.39724) */
  SELECT rh.*, fn_getname (rh.tn) fio, rp.name pos
    FROM routes_head rh, routes_pos rp
   WHERE     TRUNC (data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND (   tn IN (SELECT emp_tn
                          FROM who_full
                         WHERE exp_tn = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND rh.pos_otv = rp.id(+)
ORDER BY fio, rh.num, pos