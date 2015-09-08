/* Formatted on 17/06/2015 13:09:46 (QP5 v5.227.12220.39724) */
  SELECT fn_getname ( (SELECT DISTINCT tn_rmkk
                         FROM nets
                        WHERE tn_mkk = m.mkk_ter AND ROWNUM = 1))
            rmkk_name,
         fn_getname (m.mkk_ter) mkk_name,
         n.net_name,
         pt.pay_type,
         pt.ID pt_id,
         SUM (m.total) total
    FROM nets_plan_month m,
         statya s,
         statya gr,
         payment_format pf,
         payment_type pt,
         month_koeff mk,
         nets n
   WHERE     m.id_net = n.id_net
         AND m.YEAR = :y
         AND DECODE (:nets, 0, m.id_net, :nets) = m.id_net
         AND m.plan_type = :plan_type
         AND s.ID(+) = m.statya
         AND gr.ID(+) = s.PARENT
         AND pf.ID(+) = m.payment_format
         AND pt.ID(+) = m.payment_type
         AND mk.MONTH = m.MONTH
         AND DECODE (:plan_month, 0, m.MONTH, :plan_month) = m.MONTH
         AND (   (    m.mkk_ter IN (SELECT emp_tn
                                      FROM who_full
                                     WHERE exp_tn = :tn)
                  AND DECODE (:tn_rmkk, 0, 1, :tn_rmkk) IN
                         (SELECT tn_rmkk
                            FROM nets
                           WHERE tn_mkk = m.mkk_ter
                          UNION
                          SELECT 1 FROM DUAL)
                  AND DECODE (:tn_mkk, 0, m.mkk_ter, :tn_mkk) = m.mkk_ter)
              OR (    :tn IN (DECODE ( (SELECT pos_id
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
                  AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk))
         AND m.payment_type IN (1, 3)
GROUP BY pt.pay_type,
         pt.ID,
         m.mkk_ter,
         n.net_name
ORDER BY rmkk_name, mkk_name, n.net_name