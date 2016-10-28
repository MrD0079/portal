/* Formatted on 18/03/2016 11:32:05 (QP5 v5.252.13127.32867) */
INSERT INTO bud_ru_zay_ff (z_id, ff_id)
   SELECT z1.id, z1.ff_id
     FROM (SELECT z.id
             FROM bud_ru_zay z,
                  bud_ru_st_ras s,
                  bud_ru_ff ff,
                  bud_ru_zay_ff zff,
                  bud_ru_ff_st ffst
            WHERE     z.st = s.id
                  AND ff.dpt_id = s.dpt_id
                  AND ff.id = :ff_id
                  AND z.id = zff.z_id
                  AND ff.id = zff.ff_id
                  AND ffst.ff = ff.id
                  AND ffst.st = s.id
                  AND (SELECT accepted
                         FROM bud_ru_zay_accept
                        WHERE     z_id = z.id
                              AND accept_order =
                                     DECODE (
                                        NVL (
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND accepted = 2),
                                           0),
                                        0, (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND accepted IS NOT NULL),
                                        (SELECT MAX (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE z_id = z.id AND accepted = 2))) =
                         0) z,
          (SELECT z.id, ff.id ff_id
             FROM bud_ru_zay z,
                  bud_ru_st_ras s,
                  bud_ru_ff ff,
                  bud_ru_ff_st ffst
            WHERE     z.st = s.id
                  AND ff.dpt_id = s.dpt_id
                  AND ff.id = :ff_id
                  AND ffst.ff = ff.id
                  AND ffst.st = s.id
                  AND (SELECT accepted
                         FROM bud_ru_zay_accept
                        WHERE     z_id = z.id
                              AND accept_order =
                                     DECODE (
                                        NVL (
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND accepted = 2),
                                           0),
                                        0, (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND accepted IS NOT NULL),
                                        (SELECT MAX (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE z_id = z.id AND accepted = 2))) =
                         0) z1
    WHERE z.id(+) = z1.id AND z.id IS NULL