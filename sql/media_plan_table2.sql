/* Formatted on 24.04.2017 16:15:28 (QP5 v5.252.13127.32867) */
  SELECT tn_nmkk_net,
         nmkk_net,
         tn_tmkk_net,
         tmkk_net,
         SUM (financial_quantity) financial_quantity,
         SUM (financial_amount) financial_amount,
         SUM (contractual_quantity) contractual_quantity,
         SUM (contractual_amount) contractual_amount,
         SUM (operational_quantity) operational_quantity,
         SUM (operational_amount) operational_amount,
         SUM (rendered_quantity) rendered_quantity,
         SUM (rendered_amount) rendered_amount,
         SUM (net_plan_fin) net_plan_fin,
sum(net_plan_oper)net_plan_oper,
         SUM (net_fakt) net_fakt,
         DECODE (SUM (net_plan_fin),
                 0, 0,
                 SUM (financial_amount) / SUM (net_plan_fin) * 100)
            plan_budjet,
         DECODE (SUM (net_fakt),
                 0, 0,
                 SUM (rendered_amount) / SUM (net_fakt) * 100)
            fakt_budjet
    FROM (  SELECT tn_nmkk_net,
                   nmkk_net,
                   tn_tmkk_net,
                   tmkk_net,
                   id_net,
                   net_name,
                   month,
                   SUM (financial_quantity) financial_quantity,
                   SUM (financial_amount) financial_amount,
                   SUM (contractual_quantity) contractual_quantity,
                   SUM (contractual_amount) contractual_amount,
                   SUM (operational_quantity) operational_quantity,
                   SUM (operational_amount) operational_amount,
                   SUM (rendered_quantity) rendered_quantity,
                   SUM (rendered_amount) rendered_amount,
                   net_fakt,net_plan_oper,
                   net_plan_fin
              FROM (  SELECT n.tn_rmkk tn_nmkk_net,
                             unm.fio nmkk_net,
                             n.tn_mkk tn_tmkk_net,
                             utm.fio tmkk_net,
                             umkkter.fio mkk_territory,
                             n.id_net,
                             n.net_name,
                             sp.cost_item ñost_item_group,
                             s.cost_item ñost_item,
                             m.year,
                             m.month,
                             pf.pay_format payment_format,
                             m.descript description,
                             SUM (CASE WHEN m.plan_type = 1 THEN 1 END)
                                financial_quantity,
                             SUM (CASE WHEN m.plan_type = 1 THEN m.total END)
                                financial_amount,
                             SUM (CASE WHEN m.plan_type = 2 THEN 1 END)
                                contractual_quantity,
                             SUM (CASE WHEN m.plan_type = 2 THEN m.total END)
                                contractual_amount,
                             SUM (CASE WHEN m.plan_type = 3 THEN 1 END)
                                operational_quantity,
                             SUM (CASE WHEN m.plan_type = 3 THEN m.total END)
                                operational_amount,
                             SUM (CASE WHEN m.plan_type = 4 THEN 1 END)
                                rendered_quantity,
                             SUM (CASE WHEN m.plan_type = 4 THEN m.total END)
                                rendered_amount,
                               CASE
                                  WHEN s.parent NOT IN (42, 96882041) THEN fakt
                                  WHEN s.parent = 42 THEN fakt_ng
                                  WHEN s.parent = 96882041 THEN fakt_coffee
                               END
                             / 1000
                                net_fakt,
                   CASE
                        WHEN s.parent NOT IN (42, 96882041) THEN plan
                        WHEN s.parent = 42 THEN plan_ng
                        WHEN s.parent = 96882041 THEN plan_coffee
                     END
                      net_plan_oper,
                             sp.net_plan_fin
                        FROM nets_plan_month m,
                             nets n,
                             statya s,
                             statya sp,
                             payment_format pf,
                             user_list unm,
                             user_list utm,
                             user_list umkkter,
                             (SELECT t2.id_net,
                                     t1.year,
                                     t1.month,
                                     t1.fakt,
                                     t1.fakt_ng,
                                     t1.fakt_coffee,
                                     t1.plan,
                                     t1.plan_ng,
                                     t1.plan_coffee
                                FROM networkplanfact t1, nets t2
                               WHERE t1.id_net = t2.sw_kod) npf,
                             (SELECT y.year,
                                     mk.month,
                                     y.id_net,
                                       CASE
                                          WHEN :mgroups = 1 THEN sales
                                          WHEN :mgroups = 3 THEN sales_ng
                                          WHEN :mgroups = 2 THEN sales_coffee
                                       END
                                     / 100
                                     * CASE
                                          WHEN :mgroups = 1 THEN koeff
                                          WHEN :mgroups = 3 THEN koeff_ng
                                          WHEN :mgroups = 2 THEN koeff_coffee
                                       END
                                        net_plan_fin
                                FROM nets_plan_year y, month_koeff mk
                               WHERE y.plan_type = 1) sp
                       WHERE     TO_DATE ('1.' || m.month || '.' || m.year,
                                          'dd.mm.yyyy') BETWEEN TO_DATE (
                                                                      '1.'
                                                                   || DECODE (
                                                                         :byyear,
                                                                         1, 1,
                                                                         :plan_month)
                                                                   || '.'
                                                                   || :y,
                                                                   'dd.mm.yyyy')
                                                            AND TO_DATE (
                                                                      '1.'
                                                                   || :plan_month
                                                                   || '.'
                                                                   || :y,
                                                                   'dd.mm.yyyy')
                             AND DECODE ( :net, 0, n.id_net, :net) = n.id_net
                             AND n.id_net = m.id_net
                             AND m.statya = s.id
                             AND s.parent = sp.id
                   AND (s.id IN ( :statya_list_media_plan) or length(':statya_list_media_plan') = 1)
                             AND pf.id = m.payment_format
                             AND m.mkk_ter = umkkter.tn
                             AND n.tn_rmkk = unm.tn
                             AND n.tn_mkk = utm.tn
                             AND npf.YEAR(+) = m.year
                             AND npf.MONTH(+) = m.month
                             AND npf.id_net(+) = m.id_net
                             AND sp.YEAR(+) = m.year
                             AND sp.MONTH(+) = m.month
                             AND sp.id_net(+) = m.id_net
                             AND (    (   n.tn_mkk IN (SELECT slave
                                                         FROM full
                                                        WHERE master = :tn)
                                       OR (SELECT is_fin_man
                                             FROM user_list
                                            WHERE tn = :tn) = 1)
                                  AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) =
                                         n.tn_rmkk
                                  AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) =
                                         n.tn_mkk)
                             AND CASE
                                    WHEN s.parent NOT IN (42, 96882041) THEN 1
                                    WHEN s.parent = 42 THEN 3
                                    WHEN s.parent = 96882041 THEN 2
                                 END IN ( :mgroups)
                    GROUP BY n.id_net,
                             n.net_name,
                             m.year,
                             m.month,
                             sp.cost_item,
                             s.cost_item,
                             pf.pay_format,
                             unm.fio,
                             n.tn_rmkk,
                             n.tn_mkk,
                             utm.fio,
                             umkkter.fio,
                             m.descript,
                               CASE
                                  WHEN s.parent NOT IN (42, 96882041) THEN fakt
                                  WHEN s.parent = 42 THEN fakt_ng
                                  WHEN s.parent = 96882041 THEN fakt_coffee
                               END
                             / 1000,
CASE
                        WHEN s.parent NOT IN (42, 96882041) THEN plan
                        WHEN s.parent = 42 THEN plan_ng
                        WHEN s.parent = 96882041 THEN plan_coffee
                     END,
                             sp.net_plan_fin
                    ORDER BY year,
                             net_name,
                             ñost_item_group,
                             ñost_item,
                             year,
                             month,
                             payment_format)
          GROUP BY tn_nmkk_net,
                   nmkk_net,
                   tn_tmkk_net,
                   tmkk_net,
                   id_net,
                   net_name,
                   month,
                   net_fakt,net_plan_oper,
                   net_plan_fin)
GROUP BY tn_nmkk_net,
         nmkk_net,
         tn_tmkk_net,
         tmkk_net