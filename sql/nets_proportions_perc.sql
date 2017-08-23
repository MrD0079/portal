/* Formatted on 2011/11/28 20:38 (Formatter Plus v4.8.8) */
SELECT   ct.ID,
         ct.proportion_name,
         ty.perc perc,
         ty1.perc perc1,
         ty2.perc perc2
    FROM nets_proportions ct,
         nets_props_year ty,
         nets_props_year ty1,
         nets_props_year ty2
   WHERE ct.ID = ty.prop_id(+)
     AND :YEAR = ty.YEAR(+)
     AND :net = ty.id_net(+)
     AND ct.ID = ty1.prop_id(+)
     AND :YEAR - 1 = ty1.YEAR(+)
     AND :net = ty1.id_net(+)
     AND ct.ID = ty2.prop_id(+)
     AND :YEAR - 2 = ty2.YEAR(+)
     AND :net = ty2.id_net(+)
and ct.visible=1
ORDER BY ct.ID