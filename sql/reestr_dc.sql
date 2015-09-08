/* Formatted on 02.10.2013 16:29:08 (QP5 v5.227.12220.39724) */
  SELECT o.id,
         o.goal,
         o.findings,
         o.ok_zgdp,
         o.y,
         s.fio,
         p.pos_name,
         TO_CHAR (o.data, 'dd.mm.yyyy') data_t,
         g.name goal_name,
         g.color,
         o.tn,
         o.os_provided,
         o.os_fio,
         TO_CHAR (o.os_lu, 'dd.mm.yyyy') os_lu
    FROM os_head o,
         user_list s,
         os_goal g,
         pos p
   WHERE     o.data BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy')
                        AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
         AND o.tn = s.tn
         AND o.goal_res = g.id
         AND o.pos = p.pos_id
         AND DECODE (:ok_zgdp,  0, 0,  1, 1,  2, 0) =
                DECODE (:ok_zgdp,  0, 0,  1, o.ok_zgdp,  2, NVL (o.ok_zgdp, 0))
         AND DECODE (:os,  0, 0,  1, 1,  2, 0) =
                DECODE (:os,
                        0, 0,
                        1, o.os_provided,
                        2, NVL (o.os_provided, 0))
         AND DECODE (:pos, 0, 0, :pos) = DECODE (:pos, 0, 0, o.pos)
         AND DECODE (:goal_res, 0, 0, :goal_res) =
                DECODE (:goal_res, 0, 0, o.goal_res)
ORDER BY o.data, s.fio