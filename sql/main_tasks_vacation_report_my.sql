/* Formatted on 29/10/2014 13:27:07 (QP5 v5.227.12220.39724) */
SELECT COUNT (*)
  FROM vacation v, vacation_tasks t
 WHERE     (v.tn = :tn)
       AND v.id = t.vac_id
       /*AND NVL (t.chief_ok, 0) = 0*/
       AND SYSDATE BETWEEN v.v_to + 1 AND v.v_to + 1000
       AND NVL (v.vac_finished, 0) <> 1
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
                               WHERE sz_id = v.sz_id AND accepted = 464262))) =
              464261