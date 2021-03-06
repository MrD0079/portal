/* Formatted on 21.10.2013 16:37:19 (QP5 v5.227.12220.39724) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (SELECT tn
          FROM bud_ru_zay
         WHERE id = (SELECT z_id
                       FROM bud_ru_zay_accept
                      WHERE id = :accept_id)
        UNION
        SELECT tn
          FROM (  SELECT *
                    FROM bud_ru_zay_accept
                   WHERE     z_id = (SELECT z_id
                                       FROM bud_ru_zay_accept
                                      WHERE id = :accept_id)
                         AND accepted = 1
                ORDER BY accept_order)) z