/* Formatted on 03/02/2016 17:22:54 (QP5 v5.252.13127.32867) */
SELECT e_mail, fio
  FROM user_list
 WHERE tn IN (SELECT tn
                FROM bud_ru_zay_executors
               WHERE z_id = (SELECT z_id
                               FROM bud_ru_zay_accept
                              WHERE id = :accept_id))