/* Formatted on 21/07/2016 11:37:12 (QP5 v5.252.13127.32867) */
  SELECT current_status,
         MAX ( (SELECT name1
                  FROM accept_types
                 WHERE id = z.current_status))
            current_status_txt,
         SUM (DECODE (full, -2, 1, 0)) full2,
         SUM (DECODE (full, 1, 1, 0)) + SUM (DECODE (full, 0, 1, 0)) full01,
         COUNT (*) c,
         TO_CHAR (MIN (created_dt), 'dd.mm.yyyy') min_dt,
         TO_CHAR (MAX (created_dt), 'dd.mm.yyyy') max_dt
    FROM (SELECT DISTINCT z.*,
                          NVL (current_accepted_id, 0) current_status,
                          NVL ( (SELECT full
                                   FROM full
                                  WHERE master = :tn AND slave = z.creator_tn),
                               0)
                             full
            FROM (SELECT z.id,
                         z.created created_dt,
                         z.tn creator_tn,
                         (SELECT accepted
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        DECODE (
                                           NVL (
                                              (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND accepted = 2),
                                              0),
                                           0, (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE z_id = z.id),
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE z_id = z.id AND accepted = 2)))
                            z_current_accepted_id,
                         (SELECT rep_accepted
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id AND INN_not_ReportMA (tn) = 0
                                 AND accept_order =
                                        DECODE (
                                           NVL (
                                              (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                              0),
                                           0, (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted
                                                             IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0)))
                            current_accepted_id,
                         (SELECT tn
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        (SELECT MIN (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE     z_id = z.id
                                                AND rep_accepted = 0 AND INN_not_ReportMA (tn) = 0))
                            current_acceptor_tn,
                         (SELECT COUNT (tn)
                            FROM bud_ru_zay_accept
                           WHERE z_id = z.id AND tn = :tn)
                            i_am_is_acceptor
                    FROM bud_ru_zay z
                   WHERE     (SELECT NVL (tu, 0)
                                FROM bud_ru_st_ras
                               WHERE id = z.kat) = :tu
                         AND z.valid_no = 0
                         AND DECODE ( :st, 0, 0, :st) =
                                DECODE ( :st, 0, 0, z.st)
                         AND z.report_data IS NOT NULL
                         AND z.report_done = 1) z
           WHERE     DECODE ( :wait4myaccept, 0, :tn, 0) =
                        DECODE ( :wait4myaccept, 0, z.current_acceptor_tn, 0)
                 AND z_current_accepted_id = 1
                 AND i_am_is_acceptor <> 0
                 AND current_accepted_id = 0) z
GROUP BY current_status