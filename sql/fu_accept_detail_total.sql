/* Formatted on 15/06/2015 13:47:58 (QP5 v5.227.12220.39724) */
SELECT SUM (fin.cnt) f_cnt,
       SUM (fin.total) f_total,
       SUM (fin.bonus) f_bonus,
       SUM (oper.cnt) o_cnt,
       SUM (oper.total) o_total,
       SUM (oper.bonus) o_bonus,
       SUM (fou.cnt) u_cnt,
       SUM (fou.total) u_total,
       SUM (fou.bonus) u_bonus
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
       AND st.statya = fou.statya(+)
       AND st.statya = oper.statya(+)