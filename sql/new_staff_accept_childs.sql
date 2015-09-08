/* Formatted on 25.03.2013 13:57:08 (QP5 v5.163.1008.3004) */
  SELECT c.*, u.fio
    FROM new_staff_childs c, user_list u
   WHERE c.parent = :id AND c.tn = u.tn
ORDER BY u.fio