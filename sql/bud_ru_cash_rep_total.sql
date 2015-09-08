/* Formatted on 16.12.2013 15:04:48 (QP5 v5.227.12220.39724) */
  SELECT f.id,
         f.name,
         f.nd,
         f.rp,
         f.rf,
           NVL (f.rf, 0)
         + SUM (NVL (c_in_prev.fakt, 0) - NVL (c_out_prev.fakt, 0))
            remain_start_plan,
           NVL (f.rf, 0)
         + SUM (NVL (c_in_prev.fakt, 0) - NVL (c_out_prev.fakt, 0))
            remain_start_fakt,
         SUM (NVL (c_in_rep.plan, 0)) in_rep_plan,
         SUM (NVL (c_in_rep.fakt, 0)) in_rep_fakt,
           NVL (f.rf, 0)
         + SUM (
                NVL (c_in_prev.fakt, 0)
              - NVL (c_out_prev.fakt, 0)
              + NVL (c_in_rep.plan, 0))
            sum_start_plan,
           NVL (f.rf, 0)
         + SUM (
                NVL (c_in_prev.fakt, 0)
              - NVL (c_out_prev.fakt, 0)
              + NVL (c_in_rep.fakt, 0))
            sum_start_fakt,
         SUM (NVL (c_out_rep.plan, 0)) out_rep_plan,
         SUM (NVL (c_out_rep.fakt, 0)) out_rep_fakt,
           DECODE (
                NVL (f.rf, 0)
              + SUM (
                     NVL (c_in_prev.fakt, 0)
                   - NVL (c_out_prev.fakt, 0)
                   + NVL (c_in_rep.fakt, 0)),
              0, 0,
                SUM (NVL (c_out_rep.fakt, 0))
              / (  NVL (f.rf, 0)
                 + SUM (
                        NVL (c_in_prev.fakt, 0)
                      - NVL (c_out_prev.fakt, 0)
                      + NVL (c_in_rep.fakt, 0))))
         * 100
            out_perc_fakt,
         SUM (c_out_rep.zd_fakt) zd_fakt,
           NVL (f.rf, 0)
         + SUM (
                NVL (c_in_prev.fakt, 0)
              - NVL (c_out_prev.fakt, 0)
              + NVL (c_in_rep.plan, 0)
              - NVL (c_out_rep.plan, 0))
            sum_end_plan,
           NVL (f.rf, 0)
         + SUM (
                NVL (c_in_prev.fakt, 0)
              - NVL (c_out_prev.fakt, 0)
              + NVL (c_in_rep.fakt, 0)
              - NVL (c_out_rep.fakt, 0))
            sum_end_fakt,
         CASE WHEN SUM (c_in_rep.ok_fil) = COUNT (*) THEN 1 ELSE 0 END ok_fil
    FROM (SELECT f.*, h.db
            FROM bud_fil f, bud_ru_cash_in_head h
           WHERE f.id = h.fil
          UNION
          SELECT f.*, h.db
            FROM bud_fil f, bud_ru_cash_out_head h
           WHERE f.id = h.fil) f,
         (  SELECT h_in.fil,
                   h_in.db,
                   SUM (b_in.plan) plan,
                   SUM (b_in.fakt) fakt
              FROM bud_ru_cash_in_head h_in, bud_ru_cash_in_body b_in
             WHERE     h_in.id = b_in.head_id
                   AND h_in.dt < TO_DATE (:sd, 'dd/mm/yyyy')
          GROUP BY h_in.fil, h_in.db) c_in_prev,
         (  SELECT h_out.fil,
                   h_out.db,
                   SUM (b_out.plan) plan,
                   SUM (b_out.fakt) fakt
              FROM bud_ru_cash_out_head h_out, bud_ru_cash_out_body b_out
             WHERE     h_out.id = b_out.head_id
                   AND h_out.dt < TO_DATE (:sd, 'dd/mm/yyyy')
          GROUP BY h_out.fil, h_out.db) c_out_prev,
         (  SELECT h_in.fil,
                   h_in.db,
                   SUM (b_in.plan) plan,
                   SUM (b_in.fakt) fakt,
                   CASE WHEN SUM (ok_fil) = COUNT (*) THEN 1 ELSE 0 END ok_fil
              FROM bud_ru_cash_in_head h_in, bud_ru_cash_in_body b_in
             WHERE     h_in.id = b_in.head_id
                   AND h_in.dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                                   AND TO_DATE (:ed, 'dd/mm/yyyy')
          GROUP BY h_in.fil, h_in.db) c_in_rep,
         (  SELECT h_out.fil,
                   h_out.db,
                   SUM (b_out.plan) plan,
                   SUM (b_out.fakt) fakt,
                   SUM (b_out.zd_fakt) zd_fakt
              FROM bud_ru_cash_out_head h_out,
                   (  SELECT fil
                        FROM bud_ru_cash_out_head
                    GROUP BY fil) h_out_sum,
                   bud_ru_cash_out_body b_out
             WHERE     h_out.id = b_out.head_id
                   AND h_out_sum.fil = h_out.fil
                   AND dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                              AND TO_DATE (:ed, 'dd/mm/yyyy')
          GROUP BY h_out.fil, h_out.db) c_out_rep,
         user_list u2
   WHERE     f.id = c_in_prev.fil(+)
         AND f.id = c_out_prev.fil(+)
         AND f.id = c_in_rep.fil(+)
         AND f.id = c_out_rep.fil(+)
         AND f.db = c_in_prev.db(+)
         AND f.db = c_out_prev.db(+)
         AND f.db = c_in_rep.db(+)
         AND f.db = c_out_rep.db(+)
         /*AND f.id IN (18163033, 18163059, 18163006)*/
         AND f.db = u2.tn(+)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u2.region_name)
         AND DECODE (:db, 0, 0, :db) = DECODE (:db, 0, 0, f.db)
         AND DECODE (:fil, 0, 0, :fil) = DECODE (:fil, 0, 0, f.id)
         AND DECODE (:nd, 0, 0, :nd) = DECODE (:nd, 0, 0, f.nd)
         AND f.dpt_id = :dpt_id
         AND f.dpt_id = :dpt_id
         AND (F.DATA_END IS NULL OR F.DATA_END >= TO_DATE (:sd, 'dd/mm/yyyy'))
GROUP BY f.id,
         f.name,
         f.nd,
         f.rp,
         f.rf
ORDER BY f.name