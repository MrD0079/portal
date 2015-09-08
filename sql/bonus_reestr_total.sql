/* Formatted on 25/05/2015 16:23:42 (QP5 v5.227.12220.39724) */
SELECT SUM (summa_val) summa_val
  FROM (  SELECT h.*,
                 TO_CHAR (h.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 b.*,
                 c.mt,
                 c.y,
                 bt.name bt_name,
                 bst.name bst_name,
                 bt.koef,
                 bt.koef * b.summa summa_val,
                 (SELECT accepted
                    FROM sz_accept
                   WHERE     sz_id = h.sz_id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT accept_order
                                         FROM sz_accept
                                        WHERE     sz_id = h.sz_id
                                              AND accepted = 464262),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM sz_accept
                                        WHERE sz_id = h.sz_id),
                                   (SELECT accept_order
                                      FROM sz_accept
                                     WHERE     sz_id = h.sz_id
                                           AND accepted = 464262)))
                    sz_status_id,
                 (SELECT lu
                    FROM sz_accept
                   WHERE     sz_id = h.sz_id
                         AND accept_order =
                                DECODE (
                                   NVL (
                                      (SELECT accept_order
                                         FROM sz_accept
                                        WHERE     sz_id = h.sz_id
                                              AND accepted = 464262),
                                      0),
                                   0, (SELECT MAX (accept_order)
                                         FROM sz_accept
                                        WHERE sz_id = h.sz_id),
                                   (SELECT accept_order
                                      FROM sz_accept
                                     WHERE     sz_id = h.sz_id
                                           AND accepted = 464262)))
                    sz_accepted,
                 DECODE ( (SELECT COUNT (*)
                             FROM sz_accept
                            WHERE sz_id = h.sz_id AND accepted <> 464260),
                         0, 1,
                         0)
                    sz_not_seen
            FROM bonus_head h,
                 bonus_body b,
                 calendar c,
                 bonus_types bt,
                 bonus_types bst
           WHERE     h.id = b.bonus_id
                 AND c.data = b.mz
                 AND bt.id = h.bonus_type
                 AND bst.id = h.bonus_subtype
                 AND (SELECT accepted
                        FROM sz_accept
                       WHERE     sz_id = h.sz_id
                             AND accept_order =
                                    DECODE (
                                       NVL (
                                          (SELECT accept_order
                                             FROM sz_accept
                                            WHERE     sz_id = h.sz_id
                                                  AND accepted = 464262),
                                          0),
                                       0, (SELECT MAX (accept_order)
                                             FROM sz_accept
                                            WHERE sz_id = h.sz_id),
                                       (SELECT accept_order
                                          FROM sz_accept
                                         WHERE     sz_id = h.sz_id
                                               AND accepted = 464262))) =
                        464261
                 AND (   (    :date_between = 'mz'
                          AND (b.mz BETWEEN TO_DATE (:smz, 'dd.mm.yyyy')
                                        AND TO_DATE (:emz, 'dd.mm.yyyy')))
                      OR (    :date_between = 'cr'
                          AND (TRUNC (
                                  (SELECT lu
                                     FROM sz_accept
                                    WHERE     sz_id = h.sz_id
                                          AND accept_order =
                                                 DECODE (
                                                    NVL (
                                                       (SELECT accept_order
                                                          FROM sz_accept
                                                         WHERE     sz_id =
                                                                      h.sz_id
                                                               AND accepted =
                                                                      464262),
                                                       0),
                                                    0, (SELECT MAX (
                                                                  accept_order)
                                                          FROM sz_accept
                                                         WHERE sz_id = h.sz_id),
                                                    (SELECT accept_order
                                                       FROM sz_accept
                                                      WHERE     sz_id = h.sz_id
                                                            AND accepted =
                                                                   464262)))) BETWEEN TO_DATE (
                                                                                         :scr,
                                                                                         'dd.mm.yyyy')
                                                                                  AND TO_DATE (
                                                                                         :ecr,
                                                                                         'dd.mm.yyyy'))))
                 AND NVL (b.tn, b.chief_tn) IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (:exp_list_without_ts,
                                           0, master,
                                           :exp_list_without_ts))
                 AND NVL (b.tn, b.chief_tn) IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (:exp_list_only_ts,
                                           0, master,
                                           :exp_list_only_ts))
                 AND (   NVL (b.tn, b.chief_tn) IN (SELECT slave
                                                      FROM full
                                                     WHERE master = :tn)
                      OR (SELECT is_traid
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT is_traid_kk
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT is_coach
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND h.dpt_id = :dpt_id
                 AND DECODE (:eta_list, '', NVL (b.h_eta, '0'), :eta_list) =
                        NVL (b.h_eta, '0')
                 AND DECODE (:region_name, '0', '0', :region_name) =
                        DECODE (:region_name, '0', '0', b.region)
                 AND bst.id IN (:bst)
        ORDER BY b.mz, b.fio)