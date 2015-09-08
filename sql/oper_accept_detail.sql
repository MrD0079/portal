/* Formatted on 21.03.2012 11:47:40 (QP5 v5.163.1008.3004) */
  SELECT st.statya,
         NVL (fin.cnt, 0) f_cnt,
         DECODE (NVL (fin.cnt, 0), 0, 0, fin.total / fin.cnt) f_price,
         NVL (fin.total, 0) f_total,
         NVL (fin.bonus, 0) f_bonus,
         NVL (dog.cnt, 0) d_cnt,
         DECODE (NVL (dog.cnt, 0), 0, 0, dog.total / dog.cnt) d_price,
         NVL (dog.total, 0) d_total,
         NVL (dog.bonus, 0) d_bonus,
         NVL (oper.cnt, 0) o_cnt,
         DECODE (NVL (oper.cnt, 0), 0, 0, oper.total / oper.cnt) o_price,
         NVL (oper.total, 0) o_total,
         NVL (oper.bonus, 0) o_bonus,
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
                   AND plan_type = 2
          GROUP BY statya, payment_format) dog,
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
          GROUP BY statya, payment_format) oper
   WHERE     sn.id = st.statya
         AND st.statya = fin.statya(+)
         AND st.statya = dog.statya(+)
         AND st.statya = oper.statya(+)
         AND st.payment_format = fin.payment_format(+)
         AND st.payment_format = dog.payment_format(+)
         AND st.payment_format = oper.payment_format(+)
ORDER BY sn.cost_item, st.statya