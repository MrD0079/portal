/* Formatted on 27.11.2012 13:32:16 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (/*���������*/
        SELECT tn
          FROM sz
         WHERE id = (SELECT sz_id
                       FROM sz_accept
                      WHERE id = :accept_id)
        UNION
        /*��������� �������������*/
        SELECT tn
          FROM (  SELECT *
                    FROM sz_accept
                   WHERE sz_id = (SELECT sz_id
                                    FROM sz_accept
                                   WHERE id = :accept_id)
                         AND accepted = 464260
                ORDER BY accept_order)
         WHERE ROWNUM = 1
        UNION
        /*���������� �������������*/
        SELECT tn
          FROM (  SELECT *
                    FROM sz_accept
                   WHERE     sz_id = (SELECT sz_id
                                        FROM sz_accept
                                       WHERE id = :accept_id)
                         AND accepted = 464261
                         AND id <> :accept_id
                         AND accept_order < (SELECT accept_order
                                               FROM sz_accept
                                              WHERE id = :accept_id)
                ORDER BY accept_order)/*WHERE ROWNUM = 1*/
       ) z