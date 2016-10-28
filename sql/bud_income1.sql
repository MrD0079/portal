/* Formatted on 14.10.2016 13:56:15 (QP5 v5.252.13127.32867) */
  SELECT y,my,
         mt,
         fil_id,
         fil_name,
         SUM (opz_pt_f2) opz_pt_f2,
         SUM (opz_pt_f1) opz_pt_f1,
         SUM (opz_pt_t) opz_pt_t,
         SUM (opz_total) opz_total,
         SUM (fou_pt_f2) fou_pt_f2,
         SUM (fou_pt_f1) fou_pt_f1,
         SUM (fou_pt_t) fou_pt_t,
         SUM (fou_total) fou_total,
         SUM (bu_pt_f2) bu_pt_f2,
         SUM (bu_pt_f1) bu_pt_f1,
         SUM (bu_pt_t) bu_pt_t,
         SUM (bu_total) + NVL (FUND_OTHER, 0) bu_total,
         FUND_OTHER,
         KK_INCOME,
         COMPENSATION,
           NVL (KK_INCOME, 0)
         + NVL (COMPENSATION, 0)
         - (SUM (bu_total) + NVL (FUND_OTHER, 0))
            bu_balans,
         SUM (fou_total) - (NVL (KK_INCOME, 0) + NVL (COMPENSATION, 0))
            uu_balans,
         SUM (fou_total) - (SUM (bu_total) + NVL (FUND_OTHER, 0)) balans
    FROM (  SELECT np.y,np.my,
                   np.mt,
                   np.fil_id,
                   np.fil_name,
                   np.sw_kod,
                   np.id_net,
                   np.net_name,
                   oper_plan_zat.opz_pt_f2,
                   oper_plan_zat.opz_pt_f1,
                   oper_plan_zat.opz_pt_t,
                   oper_plan_zat.opz_total,
                   fakt_okaz_uslug.fou_pt_f2,
                   fakt_okaz_uslug.fou_pt_f1,
                   fakt_okaz_uslug.fou_pt_t,
                   fakt_okaz_uslug.fou_total,
                   buh_uchet.bu_pt_f2,
                   buh_uchet.bu_pt_f1,
                   buh_uchet.bu_pt_t,
                   buh_uchet.bu_total,
                   bi.FUND_OTHER,
                   bi.KK_INCOME,
                   bi.COMPENSATION,
                   FN_QUERY2STR (
                         '
  SELECT   ''<nobr>'' || (SELECT substr(mt,1,3) || '' '' || y
               FROM calendar
              WHERE data = i.act_prov_month)
         || '' - ''
         || trim(TO_CHAR (round(SUM (id.summa),2), ''9999999990.99''))
         || '' ''
         || pt.shortname || ''</nobr>''
            bu_act_prov_month
    FROM nets_plan_month m,
         invoice_detail id,
         invoice i,
         payment_type pt
   WHERE     id.statya = m.id
         AND i.id = id.invoice
         AND i.oplachen = 1
         AND i.act_prov_month IS NOT NULL
         AND m.plan_type = 4
         AND m.payment_type = pt.id
         AND m.payment_type IN (1, 2, 3)
         AND m.id_net = '
                      || np.id_net
                      || '
         AND m.payer = '
                      || np.fil_id
                      || '
         AND m.year = '
                      || np.y
                      || '
         AND m.month = '
                      || np.my
                      || '
GROUP BY m.id_net,
         m.payer,
         m.year,
         m.month,
         i.act_prov_month,
         pt.shortname
ORDER BY i.act_prov_month, pt.shortname',
                      ', ')
                      bu_act_prov_month
              FROM (SELECT n.sw_kod,
                           n.id_net,
                           n.net_name,
                           f.id fil_id,
                           f.name fil_name,
                           c.my,
                           c.mt,
                           c.y
                      FROM nets n, bud_fil f, calendar c
                     WHERE     (   f.data_end IS NULL
                                OR f.data_end >=
                                      (SELECT MIN (data)
                                         FROM calendar
                                        WHERE     y = :y
                                              AND ( :m = 0 OR my = :m)
                                              AND dm = 1))
                           --AND f.name LIKE 'ÊÊ_Ä%'
                           --AND n.net_name LIKE 'Á%'
                           AND f.kk = 1
                           AND n.dpt_id = f.dpt_id
                           AND n.dpt_id = :dpt_id
                           AND c.dm = 1
                           AND ( :m = 0 OR c.my = :m)
                           AND c.y = :y) np,
                   (  SELECT id_net,
                             payer,
                             year,
                             month,
                             SUM (CASE WHEN m.payment_type = 1 THEN total END)
                                opz_pt_f2,
                             SUM (CASE WHEN m.payment_type = 2 THEN total END)
                                opz_pt_f1,
                             SUM (CASE WHEN m.payment_type = 3 THEN total END)
                                opz_pt_t,
                             SUM (
                                CASE
                                   WHEN m.payment_type IN (1, 2, 3) THEN total
                                END)
                                opz_total
                        FROM nets_plan_month m
                       WHERE plan_type = 3
                    GROUP BY id_net,
                             payer,
                             year,
                             month) oper_plan_zat,
                   (  SELECT id_net,
                             payer,
                             year,
                             month,
                             SUM (CASE WHEN m.payment_type = 1 THEN total END)
                                fou_pt_f2,
                             SUM (CASE WHEN m.payment_type = 2 THEN total END)
                                fou_pt_f1,
                             SUM (CASE WHEN m.payment_type = 3 THEN total END)
                                fou_pt_t,
                             SUM (
                                CASE
                                   WHEN m.payment_type IN (1, 2, 3) THEN total
                                END)
                                fou_total
                        FROM nets_plan_month m
                       WHERE plan_type = 4
                    GROUP BY id_net,
                             payer,
                             year,
                             month) fakt_okaz_uslug,
                   (  SELECT m.id_net,
                             m.payer,
                             m.year,
                             m.month,
                             SUM (CASE WHEN m.payment_type = 1 THEN id.summa END)
                                bu_pt_f2,
                             SUM (CASE WHEN m.payment_type = 2 THEN id.summa END)
                                bu_pt_f1,
                             SUM (CASE WHEN m.payment_type = 3 THEN id.summa END)
                                bu_pt_t,
                             SUM (id.summa) bu_total
                        FROM nets_plan_month m,
                             invoice_detail id,
                             invoice i,
                             payment_type pt
                       WHERE     id.statya = m.id
                             AND i.id = id.invoice
                             AND i.oplachen = 1
                             AND i.act_prov_month IS NOT NULL
                             AND m.plan_type = 4
                             AND m.payment_type = pt.id
                             AND m.payment_type IN (1, 2, 3)
                    GROUP BY m.id_net,
                             m.payer,
                             m.year,
                             m.month) buh_uchet,
                   bud_income bi
             WHERE     np.id_net = oper_plan_zat.id_net(+)
                   AND np.fil_id = oper_plan_zat.payer(+)
                   AND np.y = oper_plan_zat.year(+)
                   AND np.my = oper_plan_zat.month(+)
                   AND np.id_net = fakt_okaz_uslug.id_net(+)
                   AND np.fil_id = fakt_okaz_uslug.payer(+)
                   AND np.y = fakt_okaz_uslug.year(+)
                   AND np.my = fakt_okaz_uslug.month(+)
                   AND np.id_net = buh_uchet.id_net(+)
                   AND np.fil_id = buh_uchet.payer(+)
                   AND np.y = buh_uchet.year(+)
                   AND np.my = buh_uchet.month(+)
                   AND np.fil_id = bi.fil_id(+)
                   AND np.y = bi.year(+)
                   AND np.my = bi.month(+)
                   AND (   oper_plan_zat.opz_pt_f2 > 0
                        OR oper_plan_zat.opz_pt_f1 > 0
                        OR oper_plan_zat.opz_pt_t > 0
                        OR fakt_okaz_uslug.fou_pt_f2 > 0
                        OR fakt_okaz_uslug.fou_pt_f1 > 0
                        OR fakt_okaz_uslug.fou_pt_t > 0
                        OR buh_uchet.bu_pt_f2 > 0
                        OR buh_uchet.bu_pt_f1 > 0
                        OR buh_uchet.bu_pt_t > 0)
          ORDER BY np.my, np.fil_name, np.net_name)
GROUP BY y,my,
         mt,
         fil_id,
         fil_name,
         FUND_OTHER,
         KK_INCOME,
         COMPENSATION
ORDER BY my, fil_name