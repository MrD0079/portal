/* Formatted on 22.02.2018 12:11:36 (QP5 v5.252.13127.32867) */
  SELECT p.id,
         p.avk,
         p.sroch,
         p.summa,
         p.perc,
         p.summa_p,
         p.dest,
         pz1.id z1_id,
         pz1.name z1_name,
         pz2.name z2_name,
         pz2.kod z2_kod,
         pz3.id z3_id,
         pz3.name z3_name,
         fn_getname (p.tn) fio,
         TO_CHAR (p.data, 'dd.mm.yyyy') data,
         pd.name rekvdpt,
         s.rekvschet,
         SUM (p1.summa_p) total_per,
         s.limitper
    FROM perech p,
         spdtree s,
         perech_zat1 pz1,
         perech_zat2 pz2,
         perech_zat3 pz3,
         perech_departments pd,
         perech p1
   WHERE     p.data BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                        AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
         AND p1.data BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                         AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
         AND p.tn = s.svideninn
         AND p.tn = p1.tn
         AND pz1.id(+) = p.zat1
         AND pz2.id(+) = p.zat2
         AND pz3.id(+) = p.zat3
         AND s.rekvdpt = pd.id(+)
GROUP BY p.id,
         p.avk,
         p.sroch,
         p.summa,
         p.perc,
         p.summa_p,
         p.dest,
         pz1.id,
         pz1.name,
         pz2.name,
         pz2.kod,
         pz3.id,
         pz3.name,
         fn_getname (p.tn),
         p.data,
         pd.name,
         s.rekvschet,
         s.limitper
ORDER BY p.data, fio