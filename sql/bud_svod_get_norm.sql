/* Formatted on 18/05/2015 17:34:51 (QP5 v5.227.12220.39724) */
SELECT n.fund, n.norm, f.kod
  FROM bud_funds f, bud_funds_norm n
 WHERE     f.id = n.fund
       AND n.dt = TO_DATE (:dt, 'dd.mm.yyyy')
       AND f.dpt_id = :dpt_id