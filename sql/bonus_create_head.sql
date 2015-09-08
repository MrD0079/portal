/* Formatted on 15/04/2015 18:29:47 (QP5 v5.227.12220.39724) */
  SELECT h.*,
         DECODE ( (SELECT COUNT (*)
                     FROM sz_accept
                    WHERE sz_id = h.sz_id AND accepted <> 464260),
                 0, 1,
                 0)
            sz_not_seen
    FROM bonus_head h
   WHERE id=:id