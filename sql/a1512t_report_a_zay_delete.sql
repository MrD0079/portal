/* Formatted on 12.30.2015 4:54:14  (QP5 v5.252.13127.32867) */
BEGIN
   DELETE FROM bud_ru_zay z
         WHERE     tn = :tn
               AND report_short = 1
               AND dt_start = TO_DATE ('01/12/2015', 'dd.mm.yyyy')
               AND dt_end = TO_DATE ('31/12/2015', 'dd.mm.yyyy')
               AND st = 66071024
               AND kat = 66071025
               AND funds = 3909729;

   COMMIT;
END;