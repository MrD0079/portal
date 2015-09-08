/* Formatted on 31/03/2014 8:55:39 (QP5 v5.227.12220.39724) */
  SELECT w.*, vp.*
    FROM dimproduct w, merch_report_vp vp
   WHERE w.product_id = vp.prod_id(+)
ORDER BY w.altgroup,
         w.Unit_Name_SW,
         w.Product_name_SW,
         w.Product_weight,
         w.product_id