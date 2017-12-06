/* Formatted on 1/4/2016 5:49:57  (QP5 v5.252.13127.32867) */
select sysdate from dual
/*BEGIN
   UPDATE bud_ru_zay_accept
      SET rep_accepted = 0
    WHERE     rep_accepted = 1
          AND z_id IN (SELECT id
                         FROM bud_ru_zay
                        WHERE     tn = :tn
                              AND report_short = 1
                              AND dt_start =
                                     TO_DATE ('01/12/2015', 'dd.mm.yyyy')
                              AND dt_end =
                                     TO_DATE ('31/12/2015', 'dd.mm.yyyy')
                              AND st = 66071024
                              AND kat = 66071025
                              AND funds = 3909729
							  and fil=:fil);

   COMMIT;

   UPDATE bud_ru_zay
      SET report_done = NULL
    WHERE     tn = :tn
          AND report_short = 1
          AND dt_start = TO_DATE ('01/12/2015', 'dd.mm.yyyy')
          AND dt_end = TO_DATE ('31/12/2015', 'dd.mm.yyyy')
          AND st = 66071024
          AND kat = 66071025
          AND funds = 3909729 and fil=:fil;

   COMMIT;
END;*/
