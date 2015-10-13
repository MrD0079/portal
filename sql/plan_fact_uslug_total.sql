/* Formatted on 17/06/2015 13:02:34 (QP5 v5.227.12220.39724) */
SELECT SUM (o_cnt) o_cnt,
       SUM (o_total) o_total,
       SUM (fu_cnt) fu_cnt,
       SUM (fu_total) fu_total,
       SUM (PLAN) PLAN,
       SUM (fakt) fakt,
       DECODE (SUM (PLAN), 0, 0, SUM (o_total) / SUM (PLAN) * 100) ef_plan,
       DECODE (SUM (fakt), 0, 0, SUM (fu_total) / SUM (fakt) * 100) ef_fakt
  FROM (  SELECT SUM (oper.cnt) o_cnt,
                 SUM (oper.total) o_total,
                 SUM (fu.cnt) fu_cnt,
                 SUM (fu.total) fu_total,
                 n.id_net,
                 n.PLAN PLAN,
                 n.fakt fakt
            FROM (SELECT n1.*, pf1.PLAN, pf1.fakt
                    FROM nets n1,
                         (  SELECT SUM (PLAN) PLAN,
                                   SUM (fakt) fakt,
                                   (SELECT id_net
                                      FROM nets
                                     WHERE sw_kod = npf.id_net)
                                      id_net
                              FROM networkplanfact npf
                             WHERE     DECODE (:calendar_months,
                                               0, MONTH,
                                               :calendar_months) = MONTH
                                   AND YEAR = :y
                          GROUP BY npf.id_net) pf1
                   WHERE n1.id_net = pf1.id_net(+)) n,
                 nets_plan_year y,
                 (SELECT DISTINCT y
                    FROM calendar
                   WHERE y = :y) cm,
                 (SELECT DISTINCT statya, id_net
                    FROM nets_plan_month m, statya s
                   WHERE     plan_type IN (3, 4)
                         AND DECODE (:payment_type,
                                     0, m.payment_type,
                                     :payment_type) = m.payment_type
                         AND s.PARENT IN (:GROUPS)
                         AND DECODE (:statya_list, 0, s.ID, :statya_list) =
                                s.ID
                         AND m.statya = s.id
                         AND DECODE (:calendar_months,
                                     0, MONTH,
                                     :calendar_months) = MONTH
                         AND YEAR = :y) st,
                 statya sn,
                 (  SELECT statya,
                           id_net,
                           SUM (cnt) cnt,
                           SUM (total) total,
                           AVG (bonus) bonus
                      FROM nets_plan_month m, statya s
                     WHERE     plan_type = 3
                           AND DECODE (:payment_type,
                                       0, m.payment_type,
                                       :payment_type) = m.payment_type
                           AND s.PARENT IN (:GROUPS)
                           AND DECODE (:statya_list, 0, s.ID, :statya_list) =
                                  s.ID
                           AND m.statya = s.id
                           AND DECODE (:calendar_months,
                                       0, MONTH,
                                       :calendar_months) = MONTH
                           AND YEAR = :y
                  GROUP BY statya, id_net) oper,
                 (  SELECT statya,
                           id_net,
                           SUM (cnt) cnt,
                           SUM (total) total,
                           AVG (bonus) bonus
                      FROM nets_plan_month m, statya s
                     WHERE     plan_type = 4
                           AND DECODE (:payment_type,
                                       0, m.payment_type,
                                       :payment_type) = m.payment_type
                           AND s.PARENT IN (:GROUPS)
                           AND DECODE (:statya_list, 0, s.ID, :statya_list) =
                                  s.ID
                           AND m.statya = s.id
                           AND DECODE (:calendar_months,
                                       0, MONTH,
                                       :calendar_months) = MONTH
                           AND YEAR = :y
                  GROUP BY statya, id_net) fu
           WHERE     n.id_net = y.id_net
                 AND y.YEAR = :y
                 AND y.plan_type = 1
                 AND cm.y = y.YEAR
                 AND sn.ID = st.statya
                 AND st.id_net = y.id_net
                 AND st.statya = oper.statya(+)
                 AND st.id_net = oper.id_net(+)
                 AND st.statya = fu.statya(+)
                 AND st.id_net = fu.id_net(+)
                 AND :tn IN (DECODE ( (SELECT pos_id
                                         FROM spdtree
                                        WHERE svideninn = :tn),
                                     24, n.tn_mkk,
                                     34, n.tn_rmkk,
                                     63, :tn,
                                     65, :tn,
                                     67, :tn,
                                     (SELECT pos_id
                                        FROM user_list
                                       WHERE tn = :tn AND is_super = 1), :tn))
                 AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                 AND DECODE (:nets, 0, n.id_net, :nets) = n.id_net
                 AND (   n.id_net IN
                            (SELECT kk_flt_nets_detail.id_net
                               FROM kk_flt_nets, kk_flt_nets_detail
                              WHERE     kk_flt_nets.id = :flt_id
                                    AND kk_flt_nets.id =
                                           kk_flt_nets_detail.id_flt)
                      OR :flt_id = 0)
        GROUP BY n.id_net, n.PLAN, n.fakt
        ORDER BY n.id_net)