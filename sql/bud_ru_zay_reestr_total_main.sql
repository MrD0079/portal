/* Formatted on 22.10.2017 13:30:40 (QP5 v5.252.13127.32867) */
SELECT SUM (DECODE (full, -2, 1, 0)) full2,
       SUM (DECODE (full, 1, 1, 0)) + SUM (DECODE (full, 0, 1, 0)) full01,
       COUNT (*) c,
       TO_CHAR (MIN (created_dt), 'dd.mm.yyyy') min_dt,
       TO_CHAR (MAX (created_dt), 'dd.mm.yyyy') max_dt
  FROM (SELECT id,
               NVL (current_accepted_id, 0) current_status,
               NVL ( (SELECT full
                        FROM full
                       WHERE master = :tn AND slave = creator_tn),
                    0)
                  full,
               DECODE (id_net, NULL, 0, 1) kk,
               is_traid,
               is_traid_kk,
               CASE
                  WHEN is_traid = 1 OR is_traid_kk = 1
                  THEN
                     CASE
                        WHEN is_traid = 1 AND id_net IS NULL THEN 1
                        WHEN is_traid_kk = 1 AND id_net IS NOT NULL THEN 1
                        ELSE 0
                     END
                  ELSE
                     1
               END
                  x,
               created_dt
          FROM (SELECT bud_ru_zay.id,
                       bud_ru_zay.created created_dt,
                       bud_ru_zay.report_data,
                       bud_ru_zay.tn creator_tn,
                       bud_ru_zay.id_net,
                       (SELECT accepted
                          FROM bud_ru_zay_accept
                         WHERE     z_id = bud_ru_zay.id
                               AND accept_order =
                                      DECODE (
                                         NVL (
                                            (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE     z_id = bud_ru_zay.id
                                                    AND accepted = 2),
                                            0),
                                         0, (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE z_id = bud_ru_zay.id),
                                         (SELECT MAX (accept_order)
                                            FROM bud_ru_zay_accept
                                           WHERE     z_id = bud_ru_zay.id
                                                 AND accepted = 2)))
                          current_accepted_id,
                       (SELECT COUNT (tn)
                          FROM bud_ru_zay_accept
                         WHERE z_id = bud_ru_zay.id AND tn = :tn)
                          i_am_is_acceptor,
                       (SELECT NVL (is_traid, 0)
                          FROM user_list
                         WHERE tn = :tn)
                          is_traid,
                       (SELECT NVL (is_traid_kk, 0)
                          FROM user_list
                         WHERE tn = :tn)
                          is_traid_kk
                  FROM bud_ru_zay, user_list u
                 WHERE     (SELECT NVL (tu, 0)
                              FROM bud_ru_st_ras
                             WHERE id = bud_ru_zay.kat) = :tu
                       AND bud_ru_zay.tn = u.tn
                       AND u.dpt_id = DECODE ( :country,
                                              '0', u.dpt_id,
                                              (SELECT dpt_id
                                                 FROM departments
                                                WHERE cnt_kod = :country))) z1
         WHERE     current_accepted_id = 1
               AND DECODE ( :who,  0, 1,  1, :tn,  2, 1) =
                      DECODE ( :who,
                              1, creator_tn,
                              2, DECODE (i_am_is_acceptor, 0, 0, 1))
               AND 2 = DECODE (report_data, NULL, 2, 1)) z
 WHERE x = 1