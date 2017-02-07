/* Formatted on 07.02.2017 17:19:07 (QP5 v5.252.13127.32867) */
  SELECT TO_NUMBER (TO_CHAR (dt_start, 'yyyy')) year,
         z.id,
         (SELECT accepted
            FROM bud_ru_zay_accept
           WHERE     z_id = z.id
                 AND accept_order =
                        DECODE (NVL ( (SELECT MAX (accept_order)
                                         FROM bud_ru_zay_accept
                                        WHERE z_id = z.id AND accepted = 2),
                                     0),
                                0, (SELECT MAX (accept_order)
                                      FROM bud_ru_zay_accept
                                     WHERE z_id = z.id),
                                (SELECT MAX (accept_order)
                                   FROM bud_ru_zay_accept
                                  WHERE z_id = z.id AND accepted = 2)))
            status
    FROM bud_ru_zay z, bud_ru_ff ff, bud_ru_zay_ff zff
   WHERE     z.id = zff.z_id
         AND zff.ff_id = ff.id
         AND (   TO_NUMBER (TO_CHAR (dt_start, 'yyyy')) =
                    (SELECT TO_NUMBER (TO_CHAR (dt_start, 'yyyy'))
                       FROM bud_ru_zay
                      WHERE id = :z_id)
              OR (    TO_NUMBER (TO_CHAR (dt_start, 'yyyy')) BETWEEN   (SELECT TO_NUMBER (
                                                                                  TO_CHAR (
                                                                                     dt_start,
                                                                                     'yyyy'))
                                                                          FROM bud_ru_zay
                                                                         WHERE id =
                                                                                  :z_id)
                                                                     - 2
                                                                 AND   (SELECT TO_NUMBER (
                                                                                  TO_CHAR (
                                                                                     dt_start,
                                                                                     'yyyy'))
                                                                          FROM bud_ru_zay
                                                                         WHERE id =
                                                                                  :z_id)
                                                                     - 1
                  AND                                           /* accepted */
                      (SELECT accepted
                         FROM bud_ru_zay_accept
                        WHERE     z_id = z.id
                              AND accept_order =
                                     DECODE (
                                        NVL (
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE z_id = z.id AND accepted = 2),
                                           0),
                                        0, (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE z_id = z.id),
                                        (SELECT MAX (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE z_id = z.id AND accepted = 2))) =
                         1
                  AND                                              /* valid */
                     valid_no = 0
                  AND                                         /* not deleted*/
                     DECODE ( (SELECT COUNT (*)
                                 FROM bud_ru_zay_accept
                                WHERE z_id = z.id AND accepted = 2),
                             0, 0,
                             1) = 0))
         AND ff.admin_id =
                DECODE (getZayFieldVal ( :z_id, 'admin_id', 13),
                        100027437, 4,
                        100027436, 14)
         AND zff.val_list =
                (SELECT zff.val_list
                   FROM bud_ru_ff ff, bud_ru_zay_ff zff
                  WHERE     zff.z_id = :z_id
                        AND zff.ff_id = ff.id
                        AND ff.admin_id =
                               DECODE (getZayFieldVal ( :z_id, 'admin_id', 13),
                                       100027437, 4,
                                       100027436, 14))
         AND (SELECT NVL (tu, 0)
                FROM bud_ru_st_ras
               WHERE id = z.kat) = 1
ORDER BY year, id