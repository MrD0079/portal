/* Formatted on 18.09.2012 10:32:02 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn,
       (SELECT TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss')
          FROM ac
         WHERE id = :ac_id)
          created,
       (SELECT head
          FROM ac
         WHERE id = :ac_id)
          head,
       :ac_id ac_id
  FROM (SELECT tn
          FROM ac_accept
         WHERE ac_id = :ac_id
               AND accept_order <= (SELECT accept_order
                                      FROM ac_accept
                                     WHERE ac_id = :ac_id AND tn = :tn)
        UNION
        SELECT tn
          FROM ac
         WHERE id = :ac_id
        MINUS
        SELECT :tn FROM DUAL) z