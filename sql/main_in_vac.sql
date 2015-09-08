/* Formatted on 12.06.2014 14:51:22 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         v.id,
         TO_CHAR (v.created, 'dd/mm/yyyy hh24:mi:ss') created,
         TO_CHAR (v.v_from, 'dd/mm/yyyy') v_from,
         TO_CHAR (v.v_to, 'dd/mm/yyyy') v_to,
         v.v_from vv_from,
         v.v_to vv_to,
         v.tn,
         u.fio,
         v.replacement,
         v.replacement_mob,
         v.replacement_mail,
         DECODE (v.replacement, NULL, v.replacement_fio_eta, u1.fio)
            replacement_fio,
         u.pos_name,
         u.department_name
    FROM vacation v, user_list u, user_list u1
   WHERE     u.dpt_id = :dpt_id
         AND u.tn = v.tn
         AND u1.tn(+) = v.replacement
         AND NVL (
                (SELECT accepted
                   FROM sz_accept
                  WHERE     sz_id = v.sz_id
                        AND accept_order =
                               DECODE (
                                  NVL (
                                     (SELECT accept_order
                                        FROM sz_accept
                                       WHERE     sz_id = v.sz_id
                                             AND accepted = 464262),
                                     0),
                                  0, (SELECT MAX (accept_order)
                                        FROM sz_accept
                                       WHERE sz_id = v.sz_id),
                                  (SELECT accept_order
                                     FROM sz_accept
                                    WHERE sz_id = v.sz_id AND accepted = 464262))),
                0) = 464261
         AND TRUNC (SYSDATE) BETWEEN v.v_from AND v.v_to
ORDER BY u.pos_name,
         vv_from,
         vv_to,
         u.fio