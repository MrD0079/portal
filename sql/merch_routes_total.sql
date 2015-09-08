/* Formatted on 29/08/2013 8:51:27 (QP5 v5.227.12220.39724) */
  SELECT fn_getname ( h.tn) svms, h.tn, COUNT (h.id) c
    FROM routes_head h, spr_users s
   WHERE h.login = S.LOGIN AND data = TO_DATE (:month_list, 'dd.mm.yyyy')
GROUP BY h.tn
ORDER BY svms