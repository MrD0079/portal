/* Formatted on 20.12.2012 16:32:41 (QP5 v5.163.1008.3004) */
  SELECT SUM (ras) ras,
         SUM (rss) rss,
         SUM (ras + rss) ras_rss,
         SUM (pri) pri,
         SUM (pds) pds,
         SUM (nsv) nsv,
         SUM (ld_ost) ld_ost,
         SUM (ppr) ppr,
         SUM (ppd) ppd,
         SUM (inv) inv,
         SUM (invent) invent,
         SUM (nsv - (ras + rss)) ek_ef,
         DECODE (NVL (SUM ( (ras + rss)), 0), 0, 0, (SUM (nsv) - SUM ( (ras + rss))) / SUM ( (ras + rss)) * 100) rent,
         SUM (vis) vis,
         ps.name p_name,
         SUM (ps.val) p_val,
         SUM (m.pri + m.inv - (m.ras + m.rss) - m.pds - m.ld_ost) ksum
    FROM (SELECT mz.id,
                 mz.name,
                 NVL ( (SELECT SUM (val)
                          FROM mz_rep_d_spr_inv
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    inv,
                 NVL ( (SELECT SUM (val)
                          FROM mz_rep_d_spr_pri
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    pri,
                 NVL ( (SELECT SUM (val)
                          FROM mz_rep_d_spr_ras
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    ras,
                 NVL ( (SELECT SUM (val)
                          FROM mz_rep_d_spr_rss
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    rss,
                 NVL ( (SELECT SUM (val)
                          FROM mz_rep_d_spr_vis
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    vis,
                 NVL ( (SELECT SUM (pds_sum)
                          FROM mz_rep_m_pds
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    pds,
                 NVL ( (SELECT SUM (invent)
                          FROM mz_rep_m
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    invent,
                 NVL ( (SELECT SUM (nsv)
                          FROM mz_rep_m
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    nsv,
                 NVL ( (SELECT SUM (ld_ost)
                          FROM mz_rep_m
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    ld_ost,
                 NVL ( (SELECT SUM (ppr)
                          FROM mz_rep_m
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    ppr,
                 NVL ( (SELECT SUM (ppd)
                          FROM mz_rep_m
                         WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND mz_id = mz.id),
                      0)
                    ppd
            FROM mz_spr_mz mz
           WHERE DECODE (:dataz,  0, 1,  1, 99,  2, 1) = DECODE (:dataz,  0, DECODE (SIGN (SYSDATE - mz.dataz), 1, 0, 1),  1, 99,  2, DECODE (SIGN (SYSDATE - mz.dataz), 1, 1, 0))) m,
         (  SELECT mz_id,
                   spr_id,
                   name,
                   SUM (val) val
              FROM mz_rep_d_spr_pri p, mz_spr_pri s
             WHERE TRUNC (dt, 'mm') BETWEEN TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm') AND LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy')) AND s.id = p.spr_id
          GROUP BY mz_id, spr_id, name) ps
   WHERE m.id = ps.mz_id
GROUP BY ps.name
ORDER BY ps.name