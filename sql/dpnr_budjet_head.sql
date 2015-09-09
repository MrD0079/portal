/* Formatted on 16/06/2015 14:24:00 (QP5 v5.227.12220.39724) */
SELECT h.ok_chief,
       h.ok_chief_fio,
       TO_CHAR (h.ok_chief_lu, 'dd.mm.yyyy hh24:mi:ss') ok_chief_lu,
       h.ok_dosp,
       h.ok_dosp_fio,
       TO_CHAR (h.ok_dosp_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dosp_lu,
       h.plan_weight,
       h.plan_sum,
       h.plan_sume,
       s.qty/1000 fakt_weight,
       s.summ_dol fakt_sum,
       s.summ_evr fakt_sume,
       (SELECT parent
          FROM parents
         WHERE tn = mt.tn)
          chief_tn
  FROM dpnr_budjet_head h,
       dpnr_market_tn mt,
       dpnr_markets m,
       sales_export s
 WHERE     h.dt = TO_DATE (:dt, 'dd.mm.yyyy')
       AND h.market = :m_id
       AND h.market = mt.m_id(+)
       AND h.market = m.id(+)
       AND m.kod = s.country_id(+)
       AND s.dt(+) = TO_DATE (:dt, 'dd.mm.yyyy')