/* Formatted on 29/08/2013 8:42:33 (QP5 v5.227.12220.39724) */
  SELECT fn_getname ( h.tn) svms,
         h.tn,
         h.num,
         h.login,
         s.password,
         h.fio_otv,
         h.gps,
         h.id
    FROM routes_head h, spr_users s
   WHERE h.login = S.LOGIN AND data = TO_DATE (:month_list, 'dd.mm.yyyy')
ORDER BY svms, h.fio_otv