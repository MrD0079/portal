/* Formatted on 27/10/2015 17:04:01 (QP5 v5.252.13127.32867) */
  SELECT b.id,
         b.creator,
         b.subj,
         c.id cid,
         c.tn,
         CASE WHEN c.tn = b.creator THEN 'инициатор' ELSE 'ДП' END
            who,
         c.text,
         TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         bc.fn,
         cr.fio creator_fio,
         cr.pos_name creator_pos_name,
         cr.department_name creator_department_name,
         b.ag_problem,
         b.ag_send_db,
         f.name fil_name,
         a.name cat_appeal_name
    FROM box_dm b,
         box_dm_chat c,
         box_dm_files bc,
         user_list cr,
         bud_fil f,
         dm_cat_appeals a
   WHERE     b.closed_init = 0
         AND b.id = c.box_id
         AND b.id = bc.box_id(+)
         AND cr.tn = b.creator
         AND b.creator = :tn
         AND b.last_dp = 1
         AND b.ag_fil = f.id(+)
         AND b.cat_appeal = a.id(+)
ORDER BY b.id, c.id