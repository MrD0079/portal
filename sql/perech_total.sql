/* Formatted on 11.01.2013 13:31:22 (QP5 v5.163.1008.3004) */
SELECT SUM (p.avk) avk,
       SUM (p.sroch) sroch,
       SUM (p.summa) summa,
       SUM (p.summa_p) summa_p
  FROM perech p,
       spdtree s,
       perech_zat1 pz1,
       perech_zat2 pz2
 WHERE data BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy') AND TO_DATE (:dates_list2, 'dd.mm.yyyy') AND p.tn = s.svideninn AND pz1.id(+) = p.zat1 AND pz2.id(+) = p.zat2