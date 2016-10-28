/* Formatted on 1/4/2016 3:53:22  (QP5 v5.252.13127.32867) */
SELECT id, sup_doc
  FROM bud_ru_zay z
 WHERE     tn = :tn
       AND report_short = 1
       AND dt_start = TO_DATE ('01/12/2015', 'dd.mm.yyyy')
       AND dt_end = TO_DATE ('31/12/2015', 'dd.mm.yyyy')
       AND st = 66071024
       AND kat = 66071025
       AND funds = 3909729
	   and sup_doc is not null