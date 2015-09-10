/* Formatted on 27.11.2012 13:32:16 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (/*инициатор*/
        SELECT tn
          FROM dzc
         WHERE id = (SELECT dzc_id
                       FROM dzc_accept
                      WHERE id = :accept_id)
        UNION
        /*следующий согласователь*/
        SELECT tn
          FROM (  SELECT *
                    FROM dzc_accept
                   WHERE dzc_id = (SELECT dzc_id
                                    FROM dzc_accept
                                   WHERE id = :accept_id)
                         AND accepted = 0
                ORDER BY accept_order)
         WHERE ROWNUM = 1
        UNION
        /*предыдущие согласователи*/
        SELECT tn
          FROM (  SELECT *
                    FROM dzc_accept
                   WHERE     dzc_id = (SELECT dzc_id
                                        FROM dzc_accept
                                       WHERE id = :accept_id)
                         AND accepted = 1
                         AND id <> :accept_id
                         AND accept_order < (SELECT accept_order
                                               FROM dzc_accept
                                              WHERE id = :accept_id)
                ORDER BY accept_order)/*WHERE ROWNUM = 1*/
       ) z