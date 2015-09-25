/* Formatted on 25/09/2015 16:06:33 (QP5 v5.227.12220.39724) */
SELECT part1,
       TO_CHAR (part1_lu, 'dd.mm.yyyy hh24:mi:ss') part1_lu,
       part1_lu_fio,
       part2,
       TO_CHAR (part2_lu, 'dd.mm.yyyy hh24:mi:ss') part2_lu,
       part2_lu_fio
  FROM mr_zpm
 WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy')