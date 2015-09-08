/* Formatted on 03.02.2014 10:31:47 (QP5 v5.227.12220.39724) */
  SELECT rh.*, fn_getname ( rh.tn) fio, rp.name pos
    FROM routes_head rh, routes_pos rp
   WHERE data = TO_DATE (:month_list, 'dd.mm.yyyy') AND rh.pos_otv = rp.id(+)
ORDER BY fio, rh.num, pos