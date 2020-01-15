/* Formatted on 12/2/2015 4:05:45  (QP5 v5.252.13127.32867) */
/*  FIX 05.10.2019 */
SELECT /*plan,*/
      /* fakt / 1000 fakt,*/
      (plan+plan_ng) as plan,
       (fakt+fakt_ng) / 1000 fakt,
       plan_ng,
       fakt_ng / 1000 fakt_ng,
       plan_coffee,
       fakt_coffee / 1000 fakt_coffee
  FROM networkplanfact npf
 WHERE     npf.YEAR = :y
       AND npf.MONTH = :m
       AND npf.id_net IN (SELECT sw_kod
                            FROM nets n
                           WHERE :net = n.id_net)