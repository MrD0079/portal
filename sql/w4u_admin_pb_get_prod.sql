/* Formatted on 02.04.2013 13:39:54 (QP5 v5.163.1008.3004) */
  SELECT p.product_name_sw, p.product_id, t.qtytt
    FROM (SELECT *
            FROM w4u_transit
           WHERE m = TO_DATE (:dt, 'dd.mm.yyyy') AND h_fio_eta = :h_fio_eta) t,
         w4u_prod p,
         w4u_vp v
   WHERE p.product_id = t.product_id(+) AND v.m = TO_DATE (:dt, 'dd.mm.yyyy') AND v.prod_id = p.product_id
ORDER BY p.product_name_sw