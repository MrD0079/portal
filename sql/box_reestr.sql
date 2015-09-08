/* Formatted on 11.06.2015 16:39:25 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (b.created, 'dd.mm.yyyy hh24:mi:ss') created,
         b.id,
         b.creator,
         b.subj,
         c.id cid,
         c.tn,
         CASE WHEN c.tn = b.creator THEN 'инициатор' ELSE 'ДП' END
            who,
         c.text,
         TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         cr.fio creator_fio,
         cr.pos_name creator_pos_name,
         cr.department_name creator_department_name
    FROM box b, box_chat c, user_list cr
   WHERE     b.id = c.box_id
         AND cr.tn = b.creator
         AND (   b.creator = :tn
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (TRUNC (b.created) BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                    AND TO_DATE (:ed, 'dd.mm.yyyy'))
         AND (:creator = 0 OR :creator = b.creator)
         AND (b.closed_dp = 1 OR b.closed_init = 1)
ORDER BY b.id, c.id