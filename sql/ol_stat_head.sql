/* Formatted on 30/10/2014 21:46:08 (QP5 v5.227.12220.39724) */
  SELECT f.tn,
         f.id,
         u.fio,
         f.chief_fio,
         u.pos_name,
         u.dpt_name,
         TO_CHAR (f.datauvol, 'dd.mm.yyyy') datauvol,
         TO_CHAR (f.accept_data, 'dd.mm.yyyy hh24:mi:ss') accept_data,
         u.dpt_name,
         o.not_accepted_cnt,
           CASE
              WHEN o.not_accepted_cnt = 0 THEN TRUNC (o.max_accepted_dt)
              ELSE TRUNC (SYSDATE)
           END
         - TRUNC (f.accept_data)
            srok,
         o.sum_plus - o.sum_minus summa,
         my_child,
         i_am_is_acceptor,
         o1.gruppa,
         det.name gr_name,
         det.fio acceptor_fio,
         det.accepted,
         TO_CHAR (det.accepted_dt, 'dd.mm.yyyy hh24:mi:ss') accepted_dt,
         det.cat,
         det.srok_det
    FROM free_staff f,
         (  SELECT free_staff_id,
                   COUNT (*) - SUM (NVL (accepted, 0)) not_accepted_cnt,
                   MAX (accepted_dt) max_accepted_dt,
                   SUM (CASE WHEN accepted = 1 THEN sum_plus ELSE 0 END) sum_plus,
                   SUM (CASE WHEN accepted = 1 THEN sum_minus ELSE 0 END)
                      sum_minus,
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
                   SUM (DECODE (:tn, tn, 1, 0)) i_am_is_acceptor
              FROM ol_staff
          GROUP BY free_staff_id
            HAVING COUNT (*) - SUM (NVL (accepted, 0)) > 0) o,
         (  SELECT free_staff_id, MIN (gruppa) gruppa
              FROM (  SELECT free_staff_id, gruppa
                        FROM ol_staff
                    GROUP BY free_staff_id, gruppa
                      HAVING COUNT (*) - SUM (NVL (accepted, 0)) > 0)
          GROUP BY free_staff_id) o1,
         (SELECT x.*,
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
                   TRUNC (NVL (x.accepted_dt, SYSDATE))
                   -trunc(x.ol_created)
                 /*- TRUNC (
                      (CASE
                          WHEN x.gruppa =
                                  (SELECT MIN (gruppa)
                                     FROM ol_staff
                                    WHERE free_staff_id = x.free_staff_id)
                          THEN
                             x.ol_created
                          ELSE
                             x1.gr_next_start
                       END))*/
                    srok_det
            FROM (SELECT os.*,
                         u.dpt_id,
                         f.accept_data ol_created,
                         f.id fid,
                         (SELECT MAX (gruppa)
                            FROM ol_staff
                           WHERE     free_staff_id = os.free_staff_id
                                 AND gruppa < os.gruppa)
                            gr_prev
                    FROM ol_staff os, free_staff f, user_list u
                   WHERE os.free_staff_id = f.id AND u.tn = f.tn) x,
                 (  SELECT o.gruppa gr_next,
                           MAX (o.accepted_dt) gr_next_start,
                           f.id
                      FROM ol_staff o,
                           free_staff f,
                           (  SELECT o.gruppa, f.id
                                FROM ol_staff o, free_staff f
                               WHERE o.free_staff_id = f.id
                            GROUP BY o.gruppa, f.id
                              HAVING COUNT (*) - SUM (NVL (o.accepted, 0)) = 0) of1
                     WHERE     o.accepted = 1
                           AND o.free_staff_id = f.id
                           AND o.gruppa = of1.gruppa
                           AND f.id = of1.id
                  GROUP BY o.gruppa, f.id) x1
           WHERE x.gr_prev = x1.gr_next(+) AND x.fid = x1.id(+)) det,
         user_list u
   WHERE     f.id = o.free_staff_id
         AND f.id = o1.free_staff_id
         AND f.tn = u.tn
         /*AND (   my_child > 0
              OR i_am_is_acceptor > 0
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)*/
         /*AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, u.tn,
                                   :exp_list_without_ts))*/
         --AND o.not_accepted_cnt = 0
         AND NVL (det.tn, 0) =
                DECODE (:acceptor_list, 0, NVL (det.tn, 0), :acceptor_list)
         AND f.accept_data BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy')
                               AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
         AND f.id = det.fid(+)
ORDER BY det.srok_det DESC NULLS LAST