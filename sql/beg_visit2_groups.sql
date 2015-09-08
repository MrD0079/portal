/* Formatted on 24.03.2014 15:38:30 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT w.h_altgroup, w.altgroup
    FROM dimproduct w, dimproduct_vp vp
   WHERE w.product_id = vp.prod_id
ORDER BY w.altgroup