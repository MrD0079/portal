/* Formatted on 11.03.2013 15:42:23 (QP5 v5.163.1008.3004) */
  SELECT w.*, vp.*
    FROM w4u_prod w,
         (SELECT v.*, p.Product_name_SW prod_link_name
            FROM w4u_vp v, w4u_prod p
           WHERE v.m = TO_DATE (:ml1, 'dd.mm.yyyy') AND v.prod_link = p.product_id(+)) vp
   WHERE w.product_id = vp.prod_id(+)
ORDER BY w.Product_Group_AVK,
         w.Unit_Name_SW,
         w.Product_name_SW,
         w.Product_weight,
         w.product_id