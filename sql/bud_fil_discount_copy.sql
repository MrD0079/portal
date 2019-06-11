/* Formatted on 18.03.2015 18:42:23 (QP5 v5.227.12220.39724) */
BEGIN
   DELETE FROM bud_fil_discount_body
         WHERE dt = TO_DATE (:dt_to, 'dd.mm.yyyy');

   INSERT INTO bud_fil_discount_body (distr,
                                      dt,
                                      discount,
                                      discount_kk,
                                      comm,
                                      fio)
      SELECT distr,
             TO_DATE (:dt_to, 'dd.mm.yyyy'),
             discount,
             discount_kk,
             comm,
             (SELECT fio
                FROM user_list
               WHERE tn = :tn)
        FROM bud_fil_discount_body
       WHERE dt = TO_DATE (:dt_from, 'dd.mm.yyyy');

   COMMIT;
END;