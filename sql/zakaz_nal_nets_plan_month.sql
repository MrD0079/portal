/* Formatted on 19/06/2015 14:56:40 (QP5 v5.227.12220.39724) */
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
         m.service_confirmed,
         fn_getname (m.tn_confirmed) tn_confirmed,
         TO_CHAR (m.date_confirmed, 'dd.mm.yyyy') date_confirmed,
         m.total_fakt,
         m.mkk_ter,
         fn_getname (m.mkk_ter) mkk_name,
         m.payer,
         f.name payer_name
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
         AND m.mkk_ter IN (SELECT emp_tn
                             FROM who_full
                            WHERE exp_tn = :tn)
         AND is_zakaz_nal = 1
ORDER BY mk.MONTH,
         groupp,
         statya,
         descript