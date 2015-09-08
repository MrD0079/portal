/* Formatted on 29.07.2015 13:31:01 (QP5 v5.227.12220.39724) */
SELECT p.val def_val,
       t.val cur_val,
       t.tn,
       t.cur_id,
       CASE
          WHEN     (SELECT COUNT (*)
                      FROM calendar
                     WHERE data = TRUNC (SYSDATE) AND dm BETWEEN 20 AND 28) =
                      1
               AND (SELECT 1 - COUNT (*)
                      FROM free_staff
                     WHERE     tn = u.tn
                           AND accepted = 1
                           AND datauvol > TRUNC (SYSDATE)) = 1
               AND (SELECT 1 - COUNT (*)
                      FROM advance_ok
                     WHERE     dpt_id = u.dpt_id
                           AND ok_ndp = 1
                           AND m = ADD_MONTHS (TRUNC (SYSDATE, 'mm'), 1)) = 1
          THEN
             1
          ELSE
             0
       END
          enabled
  FROM advance_pos p, user_list u, advance_tn t
 WHERE     p.dpt_id(+) = u.dpt_id
       AND p.pos_id(+) = u.pos_id
       AND u.tn = :tn
       AND t.tn(+) = u.tn
       AND t.m(+) = ADD_MONTHS (TRUNC (SYSDATE, 'mm'), 1)