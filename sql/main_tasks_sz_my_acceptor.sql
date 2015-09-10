/* Formatted on 21.01.2014 10:17:46 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       TO_CHAR (MIN (created), 'dd.mm.yyyy') min_dt,
       TO_CHAR (MAX (created), 'dd.mm.yyyy') max_dt
  FROM (SELECT sz.*,
               NVL (
                  (SELECT accepted
                     FROM sz_accept
                    WHERE     sz_id = sz.id
                          AND accept_order =
                                 DECODE (
                                    NVL (
                                       (SELECT accept_order
                                          FROM sz_accept
                                         WHERE     sz_id = sz.id
                                               AND accepted = 2),
                                       0),
                                    0, (SELECT MAX (accept_order)
                                          FROM sz_accept
                                         WHERE sz_id = sz.id),
                                    (SELECT accept_order
                                       FROM sz_accept
                                      WHERE     sz_id = sz.id
                                            AND accepted = 2))),
                  0)
                  current_status,
               (SELECT tn
                  FROM sz_accept
                 WHERE     sz_id = sz.id
                       AND accept_order =
                              (SELECT MIN (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = sz.id AND accepted = 0))
                  current_acceptor_tn,
               (SELECT COUNT (*)
                  FROM sz_accept
                 WHERE sz_id = sz.id)
                  accept_cnt
          FROM sz) z
 WHERE     current_acceptor_tn = :tn
       AND accept_cnt > 0
       AND current_status <> 2