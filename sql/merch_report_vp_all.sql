/* Formatted on 01/12/2014 11:47:24 (QP5 v5.227.12220.39724) */
  SELECT w.product_id, w.product_name_sw
    FROM dimproduct w, merch_report_vp vp
   WHERE w.product_id = vp.prod_id
ORDER BY w.product_name_sw