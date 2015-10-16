/* Formatted on 15/10/2015 11:14:47 (QP5 v5.252.13127.32867) */
  SELECT s.parent kat_id,
         k.cost_item kat_name,
         m.statya st_id,
         s.cost_item st_name,
         SUM (m.cnt) cnt,
         DECODE (SUM (m.cnt), 0, 0, SUM (m.total) / SUM (m.cnt)) price,
         SUM (m.total) total,
         AVG (m.bonus) bonus
    FROM nets n,
         nets_plan_month m,
         statya s,
         statya k
   WHERE     n.id_net = m.id_net
         AND m.year = :y
         AND m.plan_type = 2
         AND m.statya = s.id
         AND s.parent = k.id
         AND m.id_net = DECODE ( :nets, 0, m.id_net, :nets)
GROUP BY m.statya,
         s.parent,
         s.cost_item,
         k.cost_item
ORDER BY kat_name, st_name