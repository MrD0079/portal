/* Formatted on 21.10.2013 16:37:46 (QP5 v5.227.12220.39724) */
SELECT fn_getname ( tn) fio,
       (SELECT e_mail
          FROM user_list
         WHERE tn = z.tn)
          email,
       tn
  FROM (                                                         /*инициатор*/
        SELECT tn
          FROM bud_ru_zay
         WHERE id = (SELECT z_id
                       FROM bud_ru_zay_accept
                      WHERE id = :accept_id)
        UNION
        /*следующий согласователь*/
        SELECT tn
          FROM (  SELECT *
                    FROM bud_ru_zay_accept
                   WHERE     z_id = (SELECT z_id
                                       FROM bud_ru_zay_accept
                                      WHERE id = :accept_id)
                         AND rep_accepted = 0 AND INN_not_ReportMA (tn) = 0
                ORDER BY accept_order)
         WHERE ROWNUM = 1
        UNION
        /*предыдущие согласователи*/
        SELECT tn
          FROM (  SELECT *
                    FROM bud_ru_zay_accept
                   WHERE     z_id = (SELECT z_id
                                       FROM bud_ru_zay_accept
                                      WHERE id = :accept_id)
                         AND rep_accepted = 1 AND INN_not_ReportMA (tn) = 0
                         AND id <> :accept_id
                         AND accept_order < (SELECT accept_order
                                               FROM bud_ru_zay_accept
                                              WHERE id = :accept_id)
                ORDER BY accept_order)                    /*WHERE ROWNUM = 1*/
                                      ) z