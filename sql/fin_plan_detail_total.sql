/* Formatted on 07.11.2017 18:22:09 (QP5 v5.252.13127.32867) */
SELECT SUM (m.cnt) cnt,
       SUM (m.total) total,
       DECODE (
          DECODE ( :plan_type,  5, 4,  7, 4,  :plan_type),
          3, DECODE (
                AVG ( (SELECT NVL (SUM (PLAN), 0)
                         FROM networkplanfact
                        WHERE     id_net = (SELECT sw_kod
                                              FROM nets
                                             WHERE id_net = n.id_net)
                              AND DECODE ( :MONTH, 0, MONTH, :MONTH) = MONTH
                              AND YEAR = :y)),
                0, 0,
                  SUM (m.total)
                / AVG ( (SELECT NVL (SUM (PLAN), 0)
                           FROM networkplanfact
                          WHERE     id_net = (SELECT sw_kod
                                                FROM nets
                                               WHERE id_net = n.id_net)
                                AND DECODE ( :MONTH, 0, MONTH, :MONTH) = MONTH
                                AND YEAR = :y))
                * 100),
          4, DECODE (
                AVG ( (SELECT NVL (SUM (PLAN), 0)
                         FROM networkplanfact
                        WHERE     id_net = (SELECT sw_kod
                                              FROM nets
                                             WHERE id_net = n.id_net)
                              AND DECODE ( :MONTH, 0, MONTH, :MONTH) = MONTH
                              AND YEAR = :y)),
                0, 0,
                  SUM (m.total)
                / AVG ( (SELECT NVL (SUM (PLAN), 0)
                           FROM networkplanfact
                          WHERE     id_net = (SELECT sw_kod
                                                FROM nets
                                               WHERE id_net = n.id_net)
                                AND DECODE ( :MONTH, 0, MONTH, :MONTH) = MONTH
                                AND YEAR = :y))
                * 100),
          DECODE (
             SUM (
                NVL (
                   (SELECT sales
                      FROM nets_plan_year
                     WHERE     id_net = n.id_net
                           AND YEAR = :y
                           AND plan_type =
                                  DECODE ( :plan_type,
                                          5, 4,
                                          7, 4,
                                          :plan_type)),
                   0)),
             0, 0,
               SUM (m.total)
             / SUM (
                  (SELECT sales
                     FROM nets_plan_year
                    WHERE     id_net = n.id_net
                          AND YEAR = :y
                          AND plan_type =
                                 DECODE ( :plan_type,
                                         5, 4,
                                         7, 4,
                                         :plan_type)))
             * 100))
          perc_zatr
  FROM nets n,
       nets_plan_month m,
       statya s,
       statya gr,
       payment_format pf,
       payment_type pt,
       month_koeff mk,
       (SELECT i.summa inv_summa_vistavl,
               id.statya inv_statya,
               id.summa inv_summa,
               i.act_num inv_act_num,
               TO_CHAR (i.act_dt, 'dd.mm.yyyy') inv_act_dt,
               TO_CHAR (i.data, 'dd.mm.yyyy') inv_data,
               TO_CHAR (i.oplata_date, 'dd.mm.yyyy') inv_oplata_date,
               i.oplata_date,
               TO_CHAR (i.act_prov_month, 'dd.mm.yyyy') inv_act_prov_month,
               TO_CHAR (LAST_DAY (i.act_prov_month), 'dd.mm.yyyy')
                  inv_act_prov_month_ld,
               i.num inv_num,
               i.payer,
               p.name payer_name,
               ms.bud_z_id inv_bud_z_id,
               getZayFieldVal (ms.bud_z_id, 'admin_id', 7) bud_z_tz_address,
               i.urlic,
               ur.name ur_name
          FROM invoice_detail id,
               invoice i,
               bud_fil p,
               nets_plan_month ms,
               urlic ur
         WHERE     i.id = id.invoice
               AND :plan_type IN (5, 7)
               AND i.oplachen = 1
               AND i.payer = p.id
               AND DECODE ( :payer, 0, i.payer, :payer) = i.payer
               AND ms.id = id.statya
               AND (   ( :plan_type = 7 AND i.act_prov_month IS NOT NULL)
                    OR :plan_type <> 7)
               AND i.urlic = ur.id(+)) inv
 WHERE     (   :distr_compensation = 1
            OR :distr_compensation = 2 AND m.distr_compensation = 1
            OR :distr_compensation = 3 AND m.distr_compensation = 0)
       AND m.id = inv.inv_statya(+)
       AND DECODE ( :plan_type,  5, inv.inv_statya,  7, inv.inv_statya,  m.id) =
              m.id
       AND m.plan_type = DECODE ( :plan_type,  5, 4,  7, 4,  :plan_type)
       AND m.YEAR(+) = :y
       AND n.id_net = m.id_net(+)
       AND s.ID(+) = m.statya
       AND gr.ID(+) = s.PARENT
       AND pf.ID(+) = m.payment_format
       AND pt.ID(+) = m.payment_type
       AND mk.MONTH = m.MONTH
       AND DECODE ( :net, 0, m.id_net, :net) = m.id_net
       AND (   m.id_net IN (SELECT kk_flt_nets_detail.id_net
                              FROM kk_flt_nets, kk_flt_nets_detail
                             WHERE     kk_flt_nets.id = :flt_id
                                   AND kk_flt_nets.id =
                                          kk_flt_nets_detail.id_flt)
            OR :flt_id = 0)
       AND DECODE ( :MONTH, 0, m.MONTH, :MONTH) = m.MONTH
       AND s.PARENT IN ( :GROUPS)
       AND DECODE ( :statya_list, 0, s.ID, :statya_list) = s.ID
       AND DECODE ( :payment_type, 0, pt.ID, :payment_type) = pt.ID
       AND (   (    DECODE ( :plan_type,  5, 4,  7, 4,  :plan_type) IN (1, 2, 3)
                AND :tn IN (DECODE ( (SELECT pos_id
                                        FROM spdtree
                                       WHERE svideninn = :tn),
                                    24, n.tn_mkk,
                                    34, n.tn_rmkk,
                                    181976662, n.tn_rmkk, /* Cherkasski */
                                    63, :tn,
                                    65, :tn,
                                    67, :tn,
                                    (SELECT pos_id
                                       FROM user_list
                                      WHERE tn = :tn AND is_super = 1), :tn)))
            OR (    DECODE ( :plan_type,  5, 4,  7, 4,  :plan_type) IN (4)
                AND (   :tn IN (DECODE (
                                   (SELECT pos_id
                                      FROM spdtree
                                     WHERE svideninn = :tn),
                                   24, m.mkk_ter,
                                   34, (SELECT DISTINCT tn_rmkk
                                          FROM nets
                                         WHERE tn_mkk = m.mkk_ter),
                                   181976662, (SELECT DISTINCT tn_rmkk
                                              FROM nets
                                             WHERE tn_mkk = m.mkk_ter),
                                   63, :tn,
                                   65, :tn,
                                   67, :tn,
                                   (SELECT pos_id
                                      FROM user_list
                                     WHERE tn = :tn AND is_super = 1), :tn))
                     OR :tn = m.mkk_ter
                     OR :tn IN (SELECT tn_rmkk
                                  FROM nets
                                 WHERE tn_mkk = m.mkk_ter)))
            OR (SELECT is_admin
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
       AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
       AND (   :plan_type NOT IN (5, 7)
            OR TRUNC (NVL (inv.oplata_date, SYSDATE), 'mm') BETWEEN DECODE (
                                                                       :oms,
                                                                       '', TRUNC (
                                                                              NVL (
                                                                                 inv.oplata_date,
                                                                                 SYSDATE),
                                                                              'mm'),
                                                                       TO_DATE (
                                                                          :oms,
                                                                          'dd.mm.yyyy'))
                                                                AND DECODE (
                                                                       :ome,
                                                                       '', TRUNC (
                                                                              NVL (
                                                                                 inv.oplata_date,
                                                                                 SYSDATE),
                                                                              'mm'),
                                                                       TO_DATE (
                                                                          :ome,
                                                                          'dd.mm.yyyy')))