/* Formatted on 02.10.2013 16:32:02 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c
  FROM os_head o,
       user_list s,
       os_goal g,
       pos p
 WHERE     TRUNC (o.data, 'yyyy') = TRUNC (SYSDATE, 'yyyy')
       AND o.tn = s.tn
       AND o.goal_res = g.id
       AND o.pos = p.pos_id
       AND NVL (ok_zgdp, 0) = 0
       /*AND s.dpt_id = :dpt_id*/