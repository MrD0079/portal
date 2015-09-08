/* Formatted on 18/11/2014 16:28:05 (QP5 v5.227.12220.39724) */
  SELECT x.*,
         DECODE (:tn, x.tn, 1, 0) i_am_is_acceptor,
         CASE
            WHEN x.gruppa = (SELECT MIN (gruppa)
                               FROM ol_staff
                              WHERE free_staff_id = x.free_staff_id)
            THEN
               x.ol_created
            ELSE
               x1.gr_next_start
         END
            gr_next_start,
         TRUNC (NVL (x.accepted_dt, SYSDATE)) - TRUNC (x.ol_created) srok,
         x.name gr_name,
         DECODE ( (SELECT SUM (summi)
                     FROM ol
                    WHERE tn = :tn AND dpt_id = x.dpt_id),
                 0, 0,
                 1)
            summi_enabled
    FROM (SELECT os.*,
                 u.dpt_id,
                 f.accept_data ol_created,
                 (SELECT MAX (gruppa)
                    FROM ol_staff
                   WHERE     free_staff_id = os.free_staff_id
                         AND gruppa < os.gruppa)
                    gr_prev
            FROM ol_staff os, free_staff f, user_list u
           WHERE     os.free_staff_id = :id
                 AND os.free_staff_id = f.id
                 AND u.tn = f.tn) x,
         (  SELECT gruppa gr_next, MAX (accepted_dt) gr_next_start
              FROM ol_staff
             WHERE     accepted = 1
                   AND free_staff_id = :id
                   AND gruppa IN
                          (  SELECT gruppa
                               FROM ol_staff
                              WHERE free_staff_id = :id
                           GROUP BY gruppa
                             HAVING COUNT (*) - SUM (NVL (accepted, 0)) = 0)
          GROUP BY gruppa) x1
   WHERE     x.gr_prev = x1.gr_next(+)
         --         AND DECODE (:tn, x.tn, 1, 0) = 1 /*i_am_is_acceptor*/
         AND (   :tn = x.tn
              OR (SELECT SUM (see_all_ol)
                    FROM ol
                   WHERE tn = :tn /*AND dpt_id = x.dpt_id*/) > 0
              OR (SELECT gruppa
                    FROM ol_staff
                   WHERE free_staff_id = :id AND tn = :tn) BETWEEN 901
                                                               AND 999
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY x.gruppa, x.num