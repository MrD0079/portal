/* Formatted on 2011/12/27 09:14 (Formatter Plus v4.8.8) */
SELECT ver,
       term_id,
       pay_format,
       txt,
       summa
  FROM sdu_terms_year ty
 WHERE :YEAR = ty.YEAR(+)
   AND :net = ty.id_net(+)