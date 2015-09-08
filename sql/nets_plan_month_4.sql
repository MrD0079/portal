/* Formatted on 17/06/2015 15:28:58 (QP5 v5.227.12220.39724) */
  SELECT m.ID rid,
         m.descript,
         m.bonus,
         m.price,
         m.cnt,
         m.total,
         s.cost_item statya,
         m.statya statya_id,
         gr.cost_item groupp,
         pf.pay_format,
         pt.pay_type,
         mk.month_name,
         m.MONTH,
         gr.ID GROUP_ID,
         pf.ID pf_id,
         pt.ID pt_id,
         (SELECT DECODE (COUNT (*), 0, 0, 1)
            FROM nets_plan_month m1
           WHERE     m1.YEAR = m.YEAR
                 AND m1.id_net = m.id_net
                 AND m1.plan_type = :plan_type + 1
                 AND m1.MONTH = m.MONTH
                 AND NVL (m1.statya, 0) = NVL (m.statya, 0)
                 AND NVL (m1.payment_format, 0) = NVL (m.payment_format, 0)
                 AND NVL (m1.payment_type, 0) = NVL (m.payment_type, 0)
                 AND NVL (m1.descript, ' ') = NVL (m.descript, ' ')
                 AND NVL (m1.bonus, 0) = NVL (m.bonus, 0)
                 AND NVL (m1.price, 0) = NVL (m.price, 0)
                 AND NVL (m1.cnt, 0) = NVL (m.cnt, 0)
                 AND NVL (m1.mkk_ter, 0) = NVL (m.mkk_ter, 0))
            ok,
         m.service_confirmed,
         fn_getname (m.tn_confirmed) tn_confirmed,
         TO_CHAR (m.date_confirmed, 'dd.mm.yyyy') date_confirmed,
         m.total_fakt,
         m.mkk_ter,
         fn_getname (m.mkk_ter) mkk_name,
         bud_z_id,m.payer,f.name payer_name
    FROM nets_plan_month m,
         statya s,
         statya gr,
         payment_format pf,
         payment_type pt,
         month_koeff mk,
         nets n,
         bud_fil f
   WHERE     m.payer = f.id(+)
         AND m.id_net = n.id_net
         AND m.YEAR = :y
         AND m.id_net = :net
         AND m.plan_type = :plan_type
         AND s.ID(+) = m.statya
         AND gr.ID(+) = s.PARENT
         AND pf.ID(+) = m.payment_format
         AND pt.ID(+) = m.payment_type
         AND mk.MONTH = m.MONTH
         AND DECODE (:plan_month, 0, m.MONTH, :plan_month) = m.MONTH
         AND (   :tn IN
                    (DECODE (
                        (SELECT pos_id
                           FROM spdtree
                          WHERE svideninn = :tn),
                        24, m.mkk_ter,
                        34, (SELECT DISTINCT tn_rmkk
                               FROM nets
                              WHERE tn_mkk = m.mkk_ter),
                        63, :tn,
                        65, :tn,
                        67, :tn,
                        (SELECT pos_id
                           FROM user_list
                          WHERE tn = :tn AND (is_super = 1 OR is_admin = 1)), :tn))
              OR :tn = m.mkk_ter
              OR :tn IN (SELECT tn_rmkk
                           FROM nets
                          WHERE tn_mkk = m.mkk_ter))
ORDER BY mk.MONTH,
         groupp,
         statya,
         descript