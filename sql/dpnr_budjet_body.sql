/* Formatted on 16/06/2015 14:53:32 (QP5 v5.227.12220.39724) */
  SELECT cid,
         cname,
         spid,
         spname,
         scid,
         scname,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         MAX (comm) comm,
         DECODE ( (SELECT plan_sum
                     FROM dpnr_budjet_head
                    WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy') AND market = :m_id),
                 0, 0,
                   SUM (b.plan)
                 / (SELECT plan_sum
                      FROM dpnr_budjet_head
                     WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy') AND market = :m_id)
                 * 100)
            zat_plan,
         DECODE ( (SELECT plan_sume
                     FROM dpnr_budjet_head
                    WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy') AND market = :m_id),
                 0, 0,
                   SUM (b.plan)
                 / (SELECT plan_sume
                      FROM dpnr_budjet_head
                     WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy') AND market = :m_id)
                 * 100)
            zat_plane,
         DECODE (
            (SELECT summ_dol
               FROM dpnr_markets m, sales_export s
              WHERE     s.dt = TO_DATE (:dt, 'dd.mm.yyyy')
                    AND m.id = :m_id
                    AND m.kod = s.country_id),
            0, 0,
              SUM (b.fakt)
            / (SELECT summ_dol
                 FROM dpnr_markets m, sales_export s
                WHERE     s.dt = TO_DATE (:dt, 'dd.mm.yyyy')
                      AND m.id = :m_id
                      AND m.kod = s.country_id)
            * 100)
            zat_fakt,
         DECODE (
            (SELECT summ_evr
               FROM dpnr_markets m, sales_export s
              WHERE     s.dt = TO_DATE (:dt, 'dd.mm.yyyy')
                    AND m.id = :m_id
                    AND m.kod = s.country_id),
            0, 0,
              SUM (b.fakt)
            / (SELECT summ_evr
                 FROM dpnr_markets m, sales_export s
                WHERE     s.dt = TO_DATE (:dt, 'dd.mm.yyyy')
                      AND m.id = :m_id
                      AND m.kod = s.country_id)
            * 100)
            zat_fakte
    FROM (  SELECT c.id cid,
                   c.name cname,
                   sp.id spid,
                   sp.cost_item spname,
                   sc.id scid,
                   sc.cost_item scname
              FROM dpnr_compensations c, dpnr_statya sp, dpnr_statya sc
             WHERE sp.id = sc.parent
          ORDER BY cname, spname, scname) t,
         (SELECT *
            FROM dpnr_budjet_body
           WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy') AND market = :m_id) b
   WHERE t.cid = b.cmp(+) AND t.scid = b.st(+)
GROUP BY CUBE (cid, cname, spid, spname, scid, scname)
ORDER BY cid,
         cname,
         spid,
         spname,
         scid,
         scname