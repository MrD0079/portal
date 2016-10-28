/* Formatted on 24/06/2016 13:01:56 (QP5 v5.252.13127.32867) */
SELECT SUM (fin.cnt) f_cnt,
       SUM (fin.total) f_total,
       SUM (fin.bonus) f_bonus,
       SUM (dog.cnt) d_cnt,
       SUM (dog.total) d_total,
       SUM (dog.bonus) d_bonus,
       SUM (oper.cnt) o_cnt,
       SUM (oper.total) o_total,
       SUM (oper.bonus) o_bonus
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
                 AND plan_type = 2
        GROUP BY statya) dog,
       (  SELECT statya,
                 SUM (cnt) cnt,
                 SUM (total) total,
                 SUM (bonus) bonus
            FROM nets_plan_month
           WHERE     year = :y
                 AND month = :calendar_months
                 AND id_net = :nets
                 AND plan_type = 3
        GROUP BY statya) oper
 WHERE     sn.id = st.statya
       AND st.statya = fin.statya(+)
       AND st.statya = dog.statya(+)
       AND st.statya = oper.statya(+)
       AND CASE
              WHEN :mgroups = 0 THEN 0
              WHEN sn.parent NOT IN (42, 96882041) THEN 1
              WHEN sn.parent = 96882041 THEN 2
              WHEN sn.parent = 42 THEN 3
           END IN ( :mgroups)