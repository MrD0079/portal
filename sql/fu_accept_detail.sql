/* Formatted on 06/06/2016 17:11:03 (QP5 v5.252.13127.32867) */
  SELECT st.statya,
         NVL (fin.cnt, 0) f_cnt,
         DECODE (NVL (fin.cnt, 0), 0, 0, fin.total / fin.cnt) f_price,
         NVL (fin.total, 0) f_total,
         NVL (fin.bonus, 0) f_bonus,
         NVL (oper.cnt, 0) o_cnt,
         DECODE (NVL (oper.cnt, 0), 0, 0, oper.total / oper.cnt) o_price,
         NVL (oper.total, 0) o_total,
         NVL (oper.bonus, 0) o_bonus,
         NVL (fou.cnt, 0) u_cnt,
         DECODE (NVL (fou.cnt, 0), 0, 0, fou.total / fou.cnt) u_price,
         NVL (fou.total, 0) u_total,
         NVL (fou.bonus, 0) u_bonus,
         sn.cost_item,
         (SELECT cost_item
            FROM statya
           WHERE id = sn.parent)
            cost_item_parent
    FROM (SELECT DISTINCT statya
            FROM nets_plan_month
           WHERE year = :y AND month = :calendar_months AND id_net = :nets) st,
         statya sn,
         (  SELECT statya,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 1
          GROUP BY statya) fin,
         (  SELECT statya,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 3
          GROUP BY statya) oper,
         (  SELECT statya,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 4
          GROUP BY statya) fou
   WHERE     sn.id = st.statya
         AND st.statya = fin.statya(+)
         AND st.statya = oper.statya(+)
         AND st.statya = fou.statya(+)
ORDER BY sn.cost_item, st.statya