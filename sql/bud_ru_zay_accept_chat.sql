/* Formatted on 21.10.2013 16:32:24 (QP5 v5.227.12220.39724) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn,
       (SELECT TO_CHAR (created, 'dd.mm.yyyy hh24:mi:ss')
          FROM bud_ru_zay
         WHERE id = :z_id)
          created,
       :z_id z_id
  FROM (SELECT tn
          FROM bud_ru_zay_accept
         WHERE     z_id = :z_id
               AND accept_order <= (SELECT accept_order
                                      FROM bud_ru_zay_accept
                                     WHERE z_id = :z_id AND tn = :tn)
        UNION
        SELECT tn
          FROM bud_ru_zay
         WHERE id = :z_id
        MINUS
        SELECT :tn FROM DUAL) z