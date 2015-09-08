/* Formatted on 18.10.2013 13:34:46 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM bud_ru_ff
   WHERE id IN (SELECT ff
                  FROM bud_ru_ff_st
                 WHERE st = (SELECT parent
                               FROM bud_ru_st_ras
                              WHERE id = :kat))
ORDER BY sort, name