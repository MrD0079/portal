/* Formatted on 11/05/2016 11:32:59 (QP5 v5.252.13127.32867) */
UPDATE bud_ru_zay z
   SET z.dt_start =
          (SELECT TRUNC (MAX (lu))
             FROM bud_ru_zay_accept
            WHERE z_id = z.id),
       z.dt_end =
          CASE
             WHEN (SELECT NVL (tu, 0)
                     FROM bud_ru_st_ras
                    WHERE id = z.kat) = 1
             THEN
                  (SELECT TRUNC (MAX (lu))
                     FROM bud_ru_zay_accept
                    WHERE z_id = z.id)
                + 365
             ELSE
                LAST_DAY ( (SELECT TRUNC (MAX (lu))
                              FROM bud_ru_zay_accept
                             WHERE z_id = z.id))
          END,
       z.report_data =
            LAST_DAY ( (SELECT TRUNC (MAX (lu))
                          FROM bud_ru_zay_accept
                         WHERE z_id = z.id))
          + (SELECT days4report
               FROM bud_ru_st_ras
              WHERE id = z.kat)
 WHERE     z.id = :id
       AND z.dt_start < (SELECT TRUNC (MAX (lu))
                           FROM bud_ru_zay_accept
                          WHERE z_id = z.id)
       AND z.kat NOT IN (SELECT id
                           FROM bud_ru_st_ras
                          WHERE la = 1)