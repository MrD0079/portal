/* Formatted on 23/03/2015 15:25:01 (QP5 v5.227.12220.39724) */
UPDATE bud_ru_zay z
   SET z.report_data =
            z.dt_end
          + (SELECT days4report
               FROM bud_ru_st_ras
              WHERE id = z.kat) - 1
 WHERE     z.id = :id
       AND z.kat IN (SELECT id
                       FROM bud_ru_st_ras
                      WHERE days4report > 0)