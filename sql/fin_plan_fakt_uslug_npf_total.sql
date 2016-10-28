/* Formatted on 12/2/2015 4:03:08  (QP5 v5.252.13127.32867) */
SELECT SUM (plan) plan,
       SUM (fakt) / 1000 fakt,
       SUM (plan_ng) plan_ng,
       SUM (fakt_ng) / 1000 fakt_ng,
       SUM (plan_coffee) plan_coffee,
       SUM (fakt_coffee) / 1000 fakt_coffee
  FROM networkplanfact npf
 WHERE     npf.YEAR = :y
       AND npf.MONTH = :m
       AND npf.id_net IN (SELECT sw_kod
                            FROM nets n
                           WHERE :net = n.id_net)