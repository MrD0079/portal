/* Formatted on 22.02.2018 12:08:39 (QP5 v5.252.13127.32867) */
SELECT SUM (p.avk) avk,
       SUM (p.sroch) sroch,
       SUM (p.summa) summa,
       SUM (p.summa_p) summa_p
  FROM perech p,
       spdtree s,
       perech_zat1 pz1,
       perech_zat2 pz2,
       perech_zat3 pz3
 WHERE     data BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                    AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
       AND p.tn = s.svideninn
       AND pz1.id(+) = p.zat1
       AND pz2.id(+) = p.zat2
       AND pz3.id(+) = p.zat3