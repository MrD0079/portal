/* Formatted on 2012/01/31 22:50 (Formatter Plus v4.8.8) */
SELECT *
  FROM networkplanfact npf
 WHERE npf.YEAR = :y
   AND npf.MONTH = :m
   AND npf.id_net IN(SELECT sw_kod
                       FROM nets n
                      WHERE :net = n.id_net)