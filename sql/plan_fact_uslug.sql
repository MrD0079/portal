/* Formatted on 17/06/2015 13:02:20 (QP5 v5.227.12220.39724) */
  SELECT n.tn_rmkk,
         n.tn_mkk,
         n.id_net,
         n.net_name,
         fn_getname (n.tn_rmkk) rmkk,
         fn_getname (n.tn_mkk) mkk,
         st.statya || '.' || st.payment_format statya,
         sn.cost_item,
         (SELECT cost_item
            FROM statya
           WHERE id = sn.parent)
            cost_item_parent,
         oper.cnt o_cnt,
         DECODE (NVL (oper.cnt, 0), 0, NULL, oper.total / oper.cnt) o_price,
         oper.total o_total,
         oper.bonus o_bonus,
         oper.payment_format o_payment_format,
         fu.cnt fu_cnt,
         DECODE (NVL (fu.cnt, 0), 0, NULL, fu.total / fu.cnt) fu_price,
         fu.total fu_total,
         fu.bonus fu_bonus,
         fu.payment_format fu_payment_format
    FROM nets n,
         nets_plan_year y,
         (SELECT DISTINCT y
            FROM calendar
           WHERE y = :y) cm,
         (SELECT DISTINCT statya, id_net, payment_format
            FROM nets_plan_month m, statya s
           WHERE     plan_type IN (3, 4)
                 AND DECODE (:payment_type, 0, m.payment_type, :payment_type) =
                        m.payment_type
                 AND s.PARENT IN (:GROUPS)
                 AND DECODE (:statya_list, 0, s.ID, :statya_list) = s.ID
                 AND m.statya = s.id
                 AND DECODE (:calendar_months, 0, MONTH, :calendar_months) =
                        MONTH
                 AND YEAR = :y) st,
         statya sn,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 3
                   AND DECODE (:payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
                   AND s.PARENT IN (:GROUPS)
                   AND DECODE (:statya_list, 0, s.ID, :statya_list) = s.ID
                   AND m.statya = s.id
                   AND DECODE (:calendar_months, 0, MONTH, :calendar_months) =
                          MONTH
                   AND YEAR = :y
          GROUP BY statya, id_net, payment_format) oper,
         (  SELECT statya,
                   id_net,
                   SUM (cnt) cnt,
                   SUM (total) total,
                   SUM (bonus) bonus,
                   payment_format
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 4
                   AND DECODE (:payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
                   AND s.PARENT IN (:GROUPS)
                   AND DECODE (:statya_list, 0, s.ID, :statya_list) = s.ID
                   AND m.statya = s.id
                   AND DECODE (:calendar_months, 0, MONTH, :calendar_months) =
                          MONTH
                   AND YEAR = :y
          GROUP BY statya, id_net, payment_format) fu
   WHERE     n.id_net = y.id_net
         AND y.YEAR = :y
         AND y.plan_type = 1
         AND cm.y = y.YEAR
         AND sn.ID = st.statya
         AND st.id_net = y.id_net
         AND st.statya = oper.statya(+)
         AND st.id_net = oper.id_net(+)
         AND st.payment_format = oper.payment_format(+)
         AND st.statya = fu.statya(+)
         AND st.id_net = fu.id_net(+)
         AND st.payment_format = fu.payment_format(+)
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
                            AND kk_flt_nets.id = kk_flt_nets_detail.id_flt)
              OR :flt_id = 0)
ORDER BY n.net_name, sn.cost_item