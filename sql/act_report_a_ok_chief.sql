/* Formatted on 21/04/2016 10:39:54 (QP5 v5.252.13127.32867) */
SELECT part1, part2, DECODE (lu, NULL, 0, 1)
  FROM act_OK
 WHERE     tn = (SELECT parent
                   FROM parents
                  WHERE tn = :tn)
       AND m = :month
       AND act = :act