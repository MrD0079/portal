/* Formatted on 15/06/2015 13:46:50 (QP5 v5.227.12220.39724) */
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
    FROM (SELECT DISTINCT statya, payment_format
            FROM nets_plan_month
           WHERE year = :y AND month = :calendar_months AND id_net = :nets) st,
         statya sn,
         (  SELECT statya,
                   payment_format,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 1
          GROUP BY statya, payment_format) fin,
         (  SELECT statya,
                   payment_format,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 3
          GROUP BY statya, payment_format) oper,
         (  SELECT statya,
                   payment_format,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus
              FROM nets_plan_month
             WHERE     year = :y
                   AND month = :calendar_months
                   AND id_net = :nets
                   AND plan_type = 4
          GROUP BY statya, payment_format) fou
   WHERE     sn.id = st.statya
         AND st.statya = fin.statya(+)
         AND st.statya = oper.statya(+)
         AND st.statya = fou.statya(+)
         AND st.payment_format = fin.payment_format(+)
         AND st.payment_format = oper.payment_format(+)
         AND st.payment_format = fou.payment_format(+)
ORDER BY sn.cost_item, st.statya