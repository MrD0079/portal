/* Formatted on 31/10/2014 11:19:11 (QP5 v5.227.12220.39724) */
  SELECT f.tn,
         f.id,
         u.fio,
         f.chief_fio,
         TO_CHAR (f.accept_data, 'dd.mm.yyyy hh24:mi:ss') accept_data,
         u.dpt_name,
         TRUNC (SYSDATE) - TRUNC (f.accept_data) srok,
         o.sum_plus - o.sum_minus summa,
         my_child,
         i_am_is_acceptor,
         i_am_is_accepted,
         o1.gruppa,
         (SELECT MAX (name)
            FROM ol_staff
           WHERE gruppa = o1.gruppa)
            gr_name,
         u.pos_name,
         u.oplatakat,
         f.params,
         TO_CHAR (u.start_pos, 'dd/mm/yyyy') start_pos,
         TO_CHAR (u.start_company, 'dd/mm/yyyy') start_company,
         TO_CHAR (f.datauvol, 'dd/mm/yyyy') datauvol,
         s.name seat,
         f.sz_id
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
                   SUM (DECODE (:tn, tn, 1, 0)) i_am_is_acceptor,
                   SUM (DECODE (:tn, tn, DECODE (accepted_dt, NULL, 0, 1), 0))
                      i_am_is_accepted
              FROM ol_staff
          GROUP BY free_staff_id) o,
         (  SELECT free_staff_id, MIN (gruppa) gruppa
              FROM (  SELECT free_staff_id, gruppa
                        FROM ol_staff
                    GROUP BY free_staff_id, gruppa
                      HAVING COUNT (*) - SUM (NVL (accepted, 0)) > 0)
          GROUP BY free_staff_id) o1,
         user_list u,
         free_staff_seat s
   WHERE     f.id = o.free_staff_id
         AND f.id = o1.free_staff_id(+)
         AND f.seat = s.id(+)
         AND f.tn = u.tn
         /*         AND (   my_child > 0
                       OR i_am_is_acceptor > 0
                       OR (SELECT NVL (is_super, 0)
                             FROM user_list
                            WHERE tn = :tn) = 1
                       OR (SELECT NVL (is_admin, 0)
                             FROM user_list
                            WHERE tn = :tn) = 1)
         */
         AND (   (    i_am_is_acceptor = 1
                  AND i_am_is_accepted <> 1
                  AND i_am_is_gr_acceptor = o1.gruppa)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         /*and i_am_is_gr_acceptor=1*/
         AND (   u.tn IN
                    (SELECT slave
                       FROM full
                      WHERE master =
                               DECODE (:exp_list_without_ts,
                                       0, u.tn,
                                       :exp_list_without_ts))
              OR (SELECT COUNT (*)
                    FROM full
                   WHERE master = u.tn) = 0)
         --AND o.not_accepted_cnt > 0
ORDER BY f.accept_data