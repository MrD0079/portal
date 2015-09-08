/* Formatted on 15/06/2015 13:44:34 (QP5 v5.227.12220.39724) */
  SELECT y.no_budget,
         n.tn_rmkk,
         n.tn_mkk,
         n.id_net,
         n.net_name,
         fn_getname (n.tn_rmkk) rmkk,
         fn_getname (n.tn_mkk) mkk,
         cm.my,
         cm.mt,
         (SELECT ok_fm
            FROM nets_plan_month_ok
           WHERE     YEAR = :y
                 AND id_net = n.id_net
                 AND MONTH = cm.my
                 AND plan_type = 4)
            ok_fm,
         (SELECT msg
            FROM nets_plan_month_ok
           WHERE     YEAR = :y
                 AND id_net = n.id_net
                 AND MONTH = cm.my
                 AND plan_type = 4)
            msg
    FROM nets n,
         nets_plan_year y,
         (SELECT DISTINCT y, my, mt
            FROM calendar
           WHERE y = :y) cm
   WHERE     n.id_net = y.id_net
         AND y.YEAR = :y
         AND y.plan_type = 1
         AND cm.y = y.YEAR
         AND (   :tn IN (DECODE ( (SELECT pos_id
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
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND DECODE (:nets, 0, n.id_net, :nets) = n.id_net
         AND DECODE (:calendar_months, 0, cm.my, :calendar_months) = cm.my
         AND DECODE (
                :ok_filter,
                0, 0,
                1, (SELECT ok_fm
                      FROM nets_plan_month_ok
                     WHERE     YEAR = :y
                           AND id_net = n.id_net
                           AND MONTH = cm.my
                           AND plan_type = 4)) = 0
ORDER BY n.net_name, cm.my