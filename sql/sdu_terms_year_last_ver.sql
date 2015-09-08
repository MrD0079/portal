/* Formatted on 2011/12/27 12:31 (Formatter Plus v4.8.8) */
SELECT term_id,
       (SELECT pay_format
          FROM payment_format
         WHERE ID = ty.pay_format) pay_format,
       txt,
       summa
  FROM sdu_terms_year ty
 WHERE :YEAR = ty.YEAR
   AND :net = ty.id_net
   AND (SELECT NVL(MAX(ver), 0)
          FROM sdu
         WHERE id_net = :net
           AND YEAR = :YEAR) = ty.ver