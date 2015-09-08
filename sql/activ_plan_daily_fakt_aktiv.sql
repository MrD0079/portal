/* Formatted on 12/12/2014 17:19:19 (QP5 v5.227.12220.39724) */
SELECT a.*, u.tn
  FROM p_activity a, user_list u
 WHERE     a.tab_num = u.tab_num
       AND u.dpt_id = :dpt_id
       AND u.dpt_id = a.dpt_id
       AND u.tn = :tn
       AND a.tp_qty > 0
       AND a.dt = TO_DATE (:dt, 'dd.mm.yyyy')