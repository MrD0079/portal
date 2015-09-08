/* Formatted on 18.09.2012 10:32:02 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn,
       (SELECT TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss')
          FROM sz
         WHERE id = :sz_id)
          created,
       (SELECT head
          FROM sz
         WHERE id = :sz_id)
          head,
       :sz_id sz_id
  FROM (SELECT tn
          FROM sz_accept
         WHERE sz_id = :sz_id
               AND accept_order <= (SELECT accept_order
                                      FROM sz_accept
                                     WHERE sz_id = :sz_id AND tn = :tn)
        UNION
        SELECT tn
          FROM sz
         WHERE id = :sz_id
        MINUS
        SELECT :tn FROM DUAL) z