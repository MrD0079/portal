/* Formatted on 21/04/2016 12:14:16 (QP5 v5.252.13127.32867) */
  SELECT np.sw_kod,
         np.id_net,
         np.net_name,
         np.fil_id,
         np.fil_name,
         npf.plan,
         npf.fakt,
         oper_plan_zat.total oper_plan_zat_total,
         fakt_okaz_uslug.total fakt_okaz_uslug_total,
         fakt_oplach_uslug.total fakt_oplach_uslug_total,
         buh_uchet.total buh_uchet_total,
         NVL (fakt_okaz_uslug.total, 0) - NVL (buh_uchet.total, 0) dolg_uu_bu,
         DECODE (NVL (npf.plan, 0), 0, 0, NVL (npf.fakt, 0) / npf.plan) * 100
            perc_vipoln_sales,
           DECODE (NVL (oper_plan_zat.total, 0),
                   0, 0,
                   NVL (fakt_okaz_uslug.total, 0) / oper_plan_zat.total)
         * 100
            perc_vipoln_uslug,
           DECODE (NVL (fakt_okaz_uslug.total, 0),
                   0, 0,
                   NVL (buh_uchet.total, 0) / fakt_okaz_uslug.total)
         * 100
            perc_provod_bu_uslug
    FROM (SELECT n.sw_kod,
                 n.id_net,
                 n.net_name,
                 f.id fil_id,
                 f.name fil_name
            FROM nets n, bud_fil f
           WHERE     (   f.data_end IS NULL
                      OR f.data_end >= (SELECT data
                                          FROM calendar
                                         WHERE y = :y AND my = :m AND dm = 1))
                 AND f.kk = 1
                 AND n.dpt_id = f.dpt_id
                 AND n.dpt_id = :dpt_id
                 AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                 AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net) np,
         (SELECT id_net,
                 year,
                 month,
                 CASE
                    WHEN :mgroups = 1 THEN plan
                    WHEN :mgroups = 3 THEN plan_ng
                    WHEN :mgroups = 2 THEN plan_coffee
                 END
                    /*/ 1000*/
                    plan,
                   CASE
                      WHEN :mgroups = 1 THEN fakt
                      WHEN :mgroups = 3 THEN fakt_ng
                      WHEN :mgroups = 2 THEN fakt_coffee
                   END
                 / 1000
                    fakt
            FROM networkplanfact) npf,
         (  SELECT id_net,
                   payer,
                   year,
                   month,
                   SUM (total) total
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 3
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY id_net,
                   payer,
                   year,
                   month) oper_plan_zat,
         (  SELECT id_net,
                   payer,
                   year,
                   month,
                   SUM (total) total
              FROM nets_plan_month m, statya s
             WHERE     plan_type = 4
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY id_net,
                   payer,
                   year,
                   month) fakt_okaz_uslug,
         (  SELECT m.id_net,
                   m.payer,
                   m.year,
                   m.month,
                   SUM (id.summa) total
              FROM nets_plan_month m,
                   statya s,
                   invoice_detail id,
                   invoice i
             WHERE     id.statya = m.id
                   AND i.id = id.invoice
                   AND i.oplachen = 1
                   AND m.plan_type = 4
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY m.id_net,
                   m.payer,
                   m.year,
                   m.month) fakt_oplach_uslug,
         (  SELECT m.id_net,
                   m.payer,
                   m.year,
                   m.month,
                   SUM (id.summa) total
              FROM nets_plan_month m,
                   statya s,
                   invoice_detail id,
                   invoice i
             WHERE     id.statya = m.id
                   AND i.id = id.invoice
                   AND i.oplachen = 1
                   AND i.act_prov_month IS NOT NULL
                   AND m.plan_type = 4
                   AND CASE
                          WHEN s.parent NOT IN (42, 96882041) THEN 1
                          WHEN s.parent = 96882041 THEN 2
                          WHEN s.parent = 42 THEN 3
                       END IN ( :mgroups)
                   AND m.statya = s.id
                   AND DECODE ( :payment_type, 0, m.payment_type, :payment_type) =
                          m.payment_type
          GROUP BY m.id_net,
                   m.payer,
                   m.year,
                   m.month) buh_uchet
   WHERE     np.sw_kod = npf.id_net(+)
         AND :y = npf.year(+)
         AND :m = npf.month(+)
         AND DECODE ( :payer, 0, np.fil_id, :payer) = np.fil_id
         AND np.id_net = oper_plan_zat.id_net(+)
         AND np.fil_id = oper_plan_zat.payer(+)
         AND :y = oper_plan_zat.year(+)
         AND :m = oper_plan_zat.month(+)
         AND np.id_net = fakt_okaz_uslug.id_net(+)
         AND np.fil_id = fakt_okaz_uslug.payer(+)
         AND :y = fakt_okaz_uslug.year(+)
         AND :m = fakt_okaz_uslug.month(+)
         AND np.id_net = fakt_oplach_uslug.id_net(+)
         AND np.fil_id = fakt_oplach_uslug.payer(+)
         AND :y = fakt_oplach_uslug.year(+)
         AND :m = fakt_oplach_uslug.month(+)
         AND np.id_net = buh_uchet.id_net(+)
         AND np.fil_id = buh_uchet.payer(+)
         AND :y = buh_uchet.year(+)
         AND :m = buh_uchet.month(+)
         AND (                /*npf.plan > 0
                           OR npf.fakt > 0
                           OR */
              oper_plan_zat.total > 0
              OR fakt_okaz_uslug.total > 0
              OR fakt_oplach_uslug.total > 0
              OR buh_uchet.total > 0)
ORDER BY np.net_name, np.fil_name