/* Formatted on 15.11.2013 17:07:35 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       TO_CHAR (MIN (created), 'dd.mm.yyyy') min_dt,
       TO_CHAR (MAX (created), 'dd.mm.yyyy') max_dt
  FROM (SELECT sz.*,
               (SELECT accepted
                  FROM sz_accept
                 WHERE     sz_id = sz.id
                       AND accept_order =
                              (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = sz.id AND accepted <> 0))
                  current_accepted_id,
               (SELECT COUNT (*)
                  FROM sz_accept
                 WHERE sz_id = sz.id)
                  accept_cnt
          FROM sz) z
 WHERE     NVL (current_accepted_id, 0) = 0
       AND accept_cnt > 0
       AND tn = :tn