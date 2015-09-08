/* Formatted on 07.07.2014 15:28:58 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         v.id,
         TO_CHAR (v.created, 'dd.mm.yyyy hh24:mi:ss') created,
         TO_CHAR (v.v_from, 'dd.mm.yyyy') v_from,
         TO_CHAR (v.v_to, 'dd.mm.yyyy') v_to,
         CASE
            WHEN TRUNC (SYSDATE) BETWEEN v.v_from AND v.v_to THEN 1
            ELSE 0
         END
            in_vac,
         CASE WHEN TRUNC (SYSDATE) > v.v_to THEN 1 ELSE 0 END vac_ended,
         v.vac_finished,
         TO_CHAR (v.vac_finished_lu, 'dd.mm.yyyy hh24:mi:ss') vac_finished_lu,
         v.summary,
         v.tn,
         u.fio,
         u.pos_name,
         v.replacement,
         v.replacement_mob,
         v.replacement_mail,
         DECODE (v.replacement, NULL, v.replacement_fio_eta, u1.fio)
            replacement_fio,
         v.sz_id,
         (SELECT sz_accept_types.name1
            FROM sz_accept, sz_accept_types
           WHERE     sz_id = v.sz_id
                 AND accepted = sz_accept_types.id(+)
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            sz_status,
         (SELECT accepted
            FROM sz_accept
           WHERE     sz_id = v.sz_id
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            sz_status_id,
         (SELECT failure
            FROM sz_accept
           WHERE     sz_id = v.sz_id
                 AND accept_order =
                        DECODE (
                           NVL (
                              (SELECT accept_order
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id AND accepted = 464262),
                              0),
                           0, (SELECT MAX (accept_order)
                                 FROM sz_accept
                                WHERE sz_id = v.sz_id),
                           (SELECT accept_order
                              FROM sz_accept
                             WHERE sz_id = v.sz_id AND accepted = 464262)))
            failure,
         DECODE ( (SELECT COUNT (*)
                     FROM sz_accept
                    WHERE sz_id = v.sz_id AND accepted <> 464260),
                 0, 1,
                 0)
            sz_not_seen,
         tasks.c,
         tasks.replacement_ok,
         tasks.chief_ok,
         NVL (f1.full, 100) full,
         spl.name planned,
         spa.name paided
    FROM vacation v,
         sz,
         (  SELECT t.vac_id,
                   COUNT (*) c,
                   SUM (t.replacement_ok) replacement_ok,
                   SUM (t.chief_ok) chief_ok
              FROM vacation_tasks t
          GROUP BY t.vac_id) tasks,
         FULL f,
         FULL f1,
         user_list u,
         user_list u1,
         parents p,
         vacation_spr_planned spl,
         vacation_spr_paided spa
   WHERE     v.planned = spl.id(+)
         AND v.paided = spa.id(+)
         AND v.sz_id = sz.id
         AND v.tn = f.slave
         AND v.tn = f1.slave(+)
         AND u.tn = v.tn
         AND v.tn = p.tn
         AND p.parent = DECODE (:parent_list, 0, p.parent, :parent_list)
         /*AND (   p.parent IN (SELECT slave
                                FROM full
                               WHERE master = :parent_list)
              OR :parent_list = 0)*/
         AND u1.tn(+) = v.replacement /*(v.replacement = :tn OR v.replacement_h_eta = :eta OR v.tn = :tn)*/
         AND :tn IN (f.master, v.replacement)
         AND f1.master(+) = :tn
         AND tasks.vac_id(+) = v.id
         AND v.v_from BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy')
                          AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
         AND u.dpt_id = DECODE (:country,
                                '0', u.dpt_id,
                                (SELECT dpt_id
                                   FROM departments
                                  WHERE cnt_kod = :country))
         AND DECODE (:creator, 0, 0, :creator) = DECODE (:creator, 0, 0, v.tn)
         AND DECODE (:replacement, 0, 0, :replacement) =
                DECODE (:replacement, 0, 0, v.replacement)
         AND DECODE (:vac_pos_id, 0, 0, :vac_pos_id) =
                DECODE (:vac_pos_id, 0, 0, u.pos_id)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u.region_name)
         AND DECODE (:department_name, '0', 0, 1) =
                DECODE (
                   :department_name,
                   '0', 0,
                   DECODE (
                      (SELECT COUNT (*)
                         FROM full
                        WHERE     master IN
                                     (SELECT tn
                                        FROM user_list
                                       WHERE DECODE (
                                                :department_name,
                                                '0', '0',
                                                :department_name) =
                                                DECODE (:department_name,
                                                        '0', '0',
                                                        department_name))
                              AND slave = v.tn),
                      0, 0,
                      1))
         AND DECODE (:vac_finished,  0, 0,  1, 1,  2, NVL (v.vac_finished, 0)) =
                NVL (v.vac_finished, 0)
         AND DECODE (
                :in_vac,
                0, CASE
                      WHEN TRUNC (SYSDATE) BETWEEN v.v_from AND v.v_to THEN 1
                      ELSE 0
                   END,
                1, 1,
                2, CASE WHEN TRUNC (SYSDATE) > v.v_to THEN 1 ELSE 0 END) = 1
         AND DECODE (:full,  0, NVL (f1.full, 100),  1, -2,  2, 1,  3, 0) =
                NVL (f1.full, 100)
         AND (SELECT accepted
                FROM sz_accept
               WHERE     sz_id = v.sz_id
                     AND accept_order =
                            DECODE (
                               NVL (
                                  (SELECT accept_order
                                     FROM sz_accept
                                    WHERE sz_id = v.sz_id AND accepted = 464262),
                                  0),
                               0, (SELECT MAX (accept_order)
                                     FROM sz_accept
                                    WHERE sz_id = v.sz_id),
                               (SELECT accept_order
                                  FROM sz_accept
                                 WHERE sz_id = v.sz_id AND accepted = 464262))) = 464261
         AND DECODE (:planned, 0, 0, :planned) =
                DECODE (:planned, 0, 0, v.planned)
         AND DECODE (:paided, 0, 0, :paided) = DECODE (:paided, 0, 0, v.paided)
ORDER BY v_from DESC, u.fio