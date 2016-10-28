/* Formatted on 21/04/2016 10:40:03 (QP5 v5.252.13127.32867) */
SELECT part1,
       part2,
       id,
       TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       ok_traid
  FROM act_OK
 WHERE tn = :tn AND m = :month AND act = :act