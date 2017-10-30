/* Formatted on 22.10.2017 12:40:50 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c
  FROM (SELECT z.id,
               z.created created_dt,
               z.tn creator_tn,
               (SELECT accepted
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              DECODE (
                                 NVL ( (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id AND accepted = 2),
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
                 WHERE     z_id = z.id
                       AND INN_not_ReportMA (tn) = 0
                       AND accept_order =
                              DECODE (
                                 NVL (
                                    (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = z.id
                                            AND rep_accepted = 2
                                            AND INN_not_ReportMA (tn) = 0),
                                    0),
                                 0, (SELECT MAX (accept_order)
                                       FROM bud_ru_zay_accept
                                      WHERE     z_id = z.id
                                            AND rep_accepted IS NOT NULL
                                            AND INN_not_ReportMA (tn) = 0),
                                 (SELECT MAX (accept_order)
                                    FROM bud_ru_zay_accept
                                   WHERE     z_id = z.id
                                         AND rep_accepted = 2
                                         AND INN_not_ReportMA (tn) = 0)))
                  current_accepted_id,
               (SELECT tn
                  FROM bud_ru_zay_accept
                 WHERE     z_id = z.id
                       AND accept_order =
                              (SELECT MIN (accept_order)
                                 FROM bud_ru_zay_accept
                                WHERE     z_id = z.id
                                      AND rep_accepted = 0
                                      AND INN_not_ReportMA (tn) = 0))
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
               AND DECODE ( :st, 0, 0, :st) = DECODE ( :st, 0, 0, z.st)
               AND z.report_data IS NOT NULL
               AND z.report_done = 1) z
 WHERE     z.current_acceptor_tn = :tn
       AND z_current_accepted_id = 1
       AND i_am_is_acceptor <> 0
       AND current_accepted_id = 0