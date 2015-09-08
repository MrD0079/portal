/* Formatted on 2011/12/28 21:10 (Formatter Plus v4.8.8) */
SELECT 
       sum(fin.cnt) f_cnt,
       sum(fin.total) f_total,
       sum(fin.bonus) f_bonus,
       sum(dog.cnt) d_cnt,
       sum(dog.total) d_total,
       sum(dog.bonus) d_bonus,
       sum(oper.cnt) o_cnt,
       sum(oper.total) o_total,
       sum(oper.bonus) o_bonus
  FROM
  (select distinct statya from nets_plan_month where year=:y and month=:calendar_months and id_net=:nets) st,
  statya sn,
  (select statya,sum(cnt) cnt,sum(total) total,sum(bonus) bonus from nets_plan_month where year=:y and month=:calendar_months and id_net=:nets and plan_type=1 group by statya) fin,
  (select statya,sum(cnt) cnt,sum(total) total,sum(bonus) bonus from nets_plan_month where year=:y and month=:calendar_months and id_net=:nets and plan_type=2 group by statya) dog,
  (select statya,sum(cnt) cnt,sum(total) total,sum(bonus) bonus from nets_plan_month where year=:y and month=:calendar_months and id_net=:nets and plan_type=3 group by statya) oper
 WHERE sn.id = st.statya
 and st.statya = fin.statya(+)
 and st.statya = dog.statya(+)
 and st.statya = oper.statya(+)
 