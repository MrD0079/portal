/* Formatted on 18.09.2012 10:32:02 (QP5 v5.163.1008.3004) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn,
       (SELECT TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss')
          FROM dzc
         WHERE id = :dzc_id)
          created,
       (SELECT comm
          FROM dzc
         WHERE id = :dzc_id)
          comm,
       :dzc_id dzc_id
  FROM (SELECT tn
          FROM dzc_accept
         WHERE dzc_id = :dzc_id
               AND accept_order <= (SELECT accept_order
                                      FROM dzc_accept
                                     WHERE dzc_id = :dzc_id AND tn = :tn)
        UNION
        SELECT tn
          FROM dzc
         WHERE id = :dzc_id
        MINUS
        SELECT :tn FROM DUAL) z