/* Formatted on 30.05.2012 12:40:22 (QP5 v5.163.1008.3004) */
  SELECT n.*,
         fn_getname ( n.tn) uvol_name,
         fn_getname ( n.creator) creator_name,
         TO_CHAR (n.datauvol, 'dd.mm.yyyy') datauvol_t,
         TO_CHAR (n.block_email, 'dd.mm.yyyy') block_email_t,
         TO_CHAR (n.block_mob, 'dd.mm.yyyy') block_mob_t,
         TO_CHAR (n.block_portal, 'dd.mm.yyyy') block_portal_t
    FROM free_staff n
   WHERE accepted IS NULL
         AND (SELECT dpt_id
                FROM user_list
               WHERE tn = n.tn) = :dpt_id
ORDER BY ID