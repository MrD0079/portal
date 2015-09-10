/* Formatted on 18.06.2014 11:06:54 (QP5 v5.227.12220.39724) */
  SELECT ff.v, COUNT (xx.full) c
    FROM (  SELECT DISTINCT
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
                   TO_CHAR (v.vac_finished_lu, 'dd.mm.yyyy hh24:mi:ss')
                      vac_finished_lu,
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
                   (SELECT accept_types.name1
                      FROM sz_accept, accept_types
                     WHERE     sz_id = v.sz_id
                           AND accepted = accept_types.id(+)
                           AND accept_order =
                                  DECODE (
                                     NVL (
                                        (SELECT accept_order
                                           FROM sz_accept
                                          WHERE     sz_id = v.sz_id
                                                AND accepted = 2),
                                        0),
                                     0, (SELECT MAX (accept_order)
                                           FROM sz_accept
                                          WHERE sz_id = v.sz_id),
                                     (SELECT accept_order
                                        FROM sz_accept
                                       WHERE     sz_id = v.sz_id
                                             AND accepted = 2)))
                      sz_status,
                   (SELECT accepted
                      FROM sz_accept
                     WHERE     sz_id = v.sz_id
                           AND accept_order =
                                  DECODE (
                                     NVL (
                                        (SELECT accept_order
                                           FROM sz_accept
                                          WHERE     sz_id = v.sz_id
                                                AND accepted = 2),
                                        0),
                                     0, (SELECT MAX (accept_order)
                                           FROM sz_accept
                                          WHERE sz_id = v.sz_id),
                                     (SELECT accept_order
                                        FROM sz_accept
                                       WHERE     sz_id = v.sz_id
                                             AND accepted = 2)))
                      sz_status_id,
                   (SELECT failure
                      FROM sz_accept
                     WHERE     sz_id = v.sz_id
                           AND accept_order =
                                  DECODE (
                                     NVL (
                                        (SELECT accept_order
                                           FROM sz_accept
                                          WHERE     sz_id = v.sz_id
                                                AND accepted = 2),
                                        0),
                                     0, (SELECT MAX (accept_order)
                                           FROM sz_accept
                                          WHERE sz_id = v.sz_id),
                                     (SELECT accept_order
                                        FROM sz_accept
                                       WHERE     sz_id = v.sz_id
                                             AND accepted = 2)))
                      failure,
                   DECODE ( (SELECT COUNT (*)
                               FROM sz_accept
                              WHERE sz_id = v.sz_id AND accepted <> 0),
                           0, 1,
                           0)
                      sz_not_seen,
                   tasks.c,
                   tasks.replacement_ok,
                   tasks.chief_ok,
                   NVL (f1.full, 100) full
              FROM vacation v,
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
                   parents p
             WHERE     v.tn = f.slave
                   AND v.tn = f1.slave(+)
                   AND u.tn = v.tn
                   AND v.tn = p.tn
                   AND u1.tn(+) = v.replacement
                   AND :tn IN (f.master, v.replacement)
                   AND f1.master(+) = :tn
                   AND tasks.vac_id(+) = v.id
                   AND NVL (v.vac_finished, 0) = 0
                   AND TRUNC (SYSDATE) = TRUNC (v_to)
          ORDER BY v_from DESC, u.fio) xx,
         (SELECT DISTINCT full, 'val_' || TO_CHAR (full + 10) v FROM full) ff
   WHERE ff.full = xx.full(+)
GROUP BY ff.v