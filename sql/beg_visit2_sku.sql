/* Formatted on 31/03/2014 10:31:32 (QP5 v5.227.12220.39724) */
  SELECT p.product_id,
         p.product_name_avk,
         p.product_id sku,
         v.price,
         v.comments,
         DECODE (v.sku, NULL, NULL, 1) ispresent
    FROM (SELECT w.product_id, w.product_name_avk
            FROM dimproduct w, dimproduct_vp vp
           WHERE w.product_id = vp.prod_id AND w.h_altgroup = :grup) p,
         (SELECT s.sku, s.price, s.comments
            FROM beg_visit_head h, beg_visit_sku s
           WHERE h.id = s.head_id(+) AND h.id = :head) v
   WHERE p.product_id = v.sku(+)
ORDER BY p.product_name_avk