/* Formatted on 02.04.2018 22:38:27 (QP5 v5.252.13127.32867) */
  SELECT ct.prop_id,
         ct.proportion_name,
         ct.format_id,
         ct.format_name,
         ct.format_sort,
         ct.readonly,
         ct.y,
         ty.face face,
         ty.perc perc
    FROM (SELECT ct.id prop_id,
                 ct.proportion_name,
                 ct.visible,
                 f.id format_id,
                 f.name format_name,
                 f.sort format_sort,
                 f.readonly,
                 c.y
            FROM nets_proportions ct,
                 NETS_PROP_SHOP_FORMATS f,
                 (SELECT DISTINCT y
                    FROM calendar
                   WHERE y BETWEEN :year - 2 AND :year) c) ct,
         nets_props_year ty
   WHERE     ct.prop_id = ty.prop_id(+)
         AND ct.format_id = ty.shop_format(+)
         AND ct.y = ty.YEAR(+)
         AND :net = ty.id_net(+)
         AND ct.visible = 1
ORDER BY y, prop_id, format_sort