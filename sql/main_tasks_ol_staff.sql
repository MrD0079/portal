/* Formatted on 08/01/2014 16:51:21 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c
    FROM free_staff f,
         (  SELECT free_staff_id,
                   COUNT (*) - SUM (NVL (accepted, 0)) not_accepted_cnt,
                   MAX (accepted_dt) max_accepted_dt,
                   SUM (CASE
                           WHEN tn IN (SELECT slave
                                         FROM full
                                        WHERE master = :tn)
                           THEN
                              1
                           ELSE
                              0
                        END)
                      my_child,
                   SUM (DECODE (:tn, tn, gruppa, 0)) i_am_is_gr_acceptor,
                   SUM (DECODE (:tn, tn, 1, 0)) i_am_is_acceptor,
                   SUM (DECODE (:tn, tn, DECODE (accepted_dt, NULL, 0, 1), 0))
                      i_am_is_accepted
              FROM ol_staff
          GROUP BY free_staff_id
            HAVING COUNT (*) - SUM (NVL (accepted, 0)) > 0) o,
         (  SELECT free_staff_id, MIN (gruppa) gruppa
              FROM (  SELECT free_staff_id, gruppa
                        FROM ol_staff
                    GROUP BY free_staff_id, gruppa
                      HAVING COUNT (*) - SUM (NVL (accepted, 0)) > 0)
          GROUP BY free_staff_id) o1,
         user_list u
   WHERE     f.id = o.free_staff_id
         AND f.id = o1.free_staff_id
         AND f.tn = u.tn
         AND i_am_is_gr_acceptor = o1.gruppa
         AND i_am_is_acceptor = 1
         AND i_am_is_accepted <> 1
ORDER BY f.accept_data