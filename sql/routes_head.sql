/* Formatted on 23.05.2012 11:31:35 (QP5 v5.163.1008.3004) */
  SELECT rh.*, fn_getname ( rh.tn) fio, rp.name pos
    FROM routes_head rh, routes_pos rp
   WHERE     data = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn)
         AND rh.pos_otv = rp.id(+)
ORDER BY fio, rh.num, pos