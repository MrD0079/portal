/* Formatted on 10/05/2016 16:43:43 (QP5 v5.252.13127.32867) */
  SELECT t.y,
         t.mt,
         t.mname,
         t.spname,
         t.scname,
         t.cname,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         TRIM (
            ';' FROM wm_concat (
                        CASE
                           WHEN LENGTH (comm) > 0 THEN ';' || comm
                           ELSE NULL
                        END))
            comm
    FROM (  SELECT c.id cid,
                   c.name cname,
                   sp.id spid,
                   sp.cost_item spname,
                   sc.id scid,
                   sc.cost_item scname,
                   m.id mid,
                   m.name mname,
                   c.data,
                   c.y,
                   c.mt
              FROM dpnr_compensations c,
                   dpnr_statya sp,
                   dpnr_statya sc,
                   dpnr_markets m,
                   (SELECT data, y, mt
                      FROM calendar
                     WHERE data = TRUNC (data, 'mm')) c
             WHERE     sp.id = sc.parent
                   AND c.data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                  AND TO_DATE ( :ed, 'dd.mm.yyyy')
                   AND m.id IN ( :m_id)
          ORDER BY cname, spname, scname) t,
         (SELECT b.*
            FROM dpnr_budjet_body b,
                 dpnr_budjet_head h,
                 (SELECT DISTINCT m_id
                    FROM dpnr_market_tn
                   WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
           WHERE     b.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                              AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND b.market IN ( :m_id)
                 AND b.market = mt.m_id
                 AND b.market = h.market(+)
                 AND b.dt = h.dt(+)
                 AND (   :ok_chief = 1
                      OR :ok_chief = 2 AND h.ok_chief = 1
                      OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)) b
   WHERE     t.cid = b.cmp(+)
         AND t.scid = b.st(+)
         AND t.mid = b.market(+)
         AND t.data = b.dt(+)
GROUP BY t.y,
         t.mt,
         t.mname,
         t.spname,
         t.scname,
         t.cname
ORDER BY t.y,
         t.mt,
         t.mname,
         t.spname,
         t.scname,
         t.cname