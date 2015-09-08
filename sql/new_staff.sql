/* Formatted on 25.03.2013 13:55:10 (QP5 v5.163.1008.3004) */
  SELECT n.*, TO_CHAR (n.datastart, 'dd.mm.yyyy') datastart_t, fn_getname ( n.creator) creator_name
    FROM new_staff n
   WHERE dpt_id = :dpt_id AND accepted IS NULL
ORDER BY ID