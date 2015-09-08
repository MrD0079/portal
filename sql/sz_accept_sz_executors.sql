/* Formatted on 17.09.2012 14:33:05 (QP5 v5.163.1008.3004) */
SELECT e_mail, fio
  FROM user_list
 WHERE tn IN (SELECT tn
                FROM sz_executors
               WHERE sz_id = (SELECT sz_id
                                FROM sz_accept
                               WHERE id = :accept_id))