/* Formatted on 20/11/2014 14:10:10 (QP5 v5.227.12220.39724) */
SELECT NVL (no_budget, 0) no_budget,
       NVL (ok_rmkk_tmkk, 0) ok_rmkk_tmkk,
       NVL (ok_fin_man, 0) ok_fin_man,
       NVL (ok_dpu, 0) ok_dpu,
       NVL (tz, 0) tz,
       NVL (zal_prognoz, 0) zal_prognoz,
       condition,
       specified_period,
       pay_type,
       pay_days,
       pay_detail,
       dus_type,
       du_complete,
       TO_CHAR (du_complete_date, 'dd.mm.yyyy') du_complete_date
  FROM nets n, nets_plan_year y
 WHERE     n.id_net = :net
       AND N.ID_NET = Y.ID_NET(+)
       AND y.year(+) = :year
       AND y.plan_type(+) = :plan_type