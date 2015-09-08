/* Formatted on 06.08.2012 17:28:49 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (SELECT tn
          FROM sz
         WHERE id = (SELECT sz_id
                       FROM sz_accept
                      WHERE id = :accept_id)
        UNION
        SELECT tn
          FROM (  SELECT *
                    FROM sz_accept
                   WHERE sz_id = (SELECT sz_id
                                    FROM sz_accept
                                   WHERE id = :accept_id)
                         AND accepted = 464261
                ORDER BY accept_order)) z