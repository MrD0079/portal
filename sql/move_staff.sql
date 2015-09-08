/* Formatted on 13.02.2014 12:50:00 (QP5 v5.227.12220.39724) */
  SELECT n.*,
         fn_getname ( n.tn) uvol_name,
         fn_getname ( n.creator) creator_name,
         TO_CHAR (n.datamove, 'dd.mm.yyyy') datamove_t
    FROM move_staff n
   WHERE     accepted IS NULL
         AND (SELECT dpt_id
                FROM user_list
               WHERE tn = n.tn) = :dpt_id
ORDER BY ID