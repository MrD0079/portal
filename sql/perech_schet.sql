/* Formatted on 11.01.2013 13:31:13 (QP5 v5.163.1008.3004) */
SELECT p.*,
       s.*,
       fn_getname ( p.tn) fio,
       TO_CHAR (p.data, 'yyyy') y,
       TO_CHAR (p.data, 'dd.mm.yyyy') data_p,
       TO_CHAR (s.dogovordata, 'dd.mm.yyyy') dogovordata_p,
       pz1.id z1_id,
       pz1.name z1_name,
       pz2.name z2_name,
       pz2.kod z2_kod
  FROM perech p,
       spdtree s,
       perech_zat1 pz1,
       perech_zat2 pz2
 WHERE p.id = :id AND p.tn = s.svideninn AND pz1.id(+) = p.zat1 AND pz2.id(+) = p.zat2