/* Formatted on 11.01.2013 13:31:03 (QP5 v5.163.1008.3004) */
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
         fn_getname ( p.tn) fio,
         TO_CHAR (p.data, 'dd.mm.yyyy') data,
         pd.name rekvdpt,
         s.rekvschet,
         SUM (p1.summa_p) total_per,
         s.limitper
    FROM perech p,
         spdtree s,
         perech_zat1 pz1,
         perech_zat2 pz2,
         perech_departments pd,
         perech p1
   WHERE     p.data BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy') AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
         AND p1.data BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy') AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
         AND p.tn = s.svideninn
         AND p.tn = p1.tn
         AND pz1.id(+) = p.zat1
         AND pz2.id(+) = p.zat2
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
         fn_getname ( p.tn),
         p.data,
         pd.name,
         s.rekvschet,
         s.limitper
ORDER BY p.data, fio