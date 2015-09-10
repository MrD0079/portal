/* Formatted on 07.08.2012 11:15:48 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (SELECT tn
          FROM (  SELECT *
                    FROM ac_accept
                   WHERE ac_id = (SELECT ac_id
                                    FROM ac_accept
                                   WHERE id = :accept_id)
                         AND accepted = 0
                ORDER BY accept_order)) z