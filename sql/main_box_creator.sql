/* Formatted on 11.06.2015 16:39:12 (QP5 v5.227.12220.39724) */
  SELECT b.id,
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
   WHERE     b.closed_init = 0
         AND b.id = c.box_id
         AND cr.tn = b.creator
         AND b.creator = :tn
         AND b.last_dp = 1
ORDER BY b.id, c.id