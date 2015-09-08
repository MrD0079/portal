/* Formatted on 22.08.2014 16:26:27 (QP5 v5.227.12220.39724) */
  SELECT v.*,
         TO_CHAR (vac_finished_lu, 'dd.mm.yyyy hh24:mi:ss') vac_finished_lu,
         u.fio,
         CASE WHEN v.replacement = :tn OR v.replacement_h_eta = :eta THEN 1 END
            i_am_replacement,
         CASE WHEN v.tn = :tn THEN 1 END i_am_vac,
         DECODE (v.replacement, NULL, v.replacement_fio_eta, u1.fio)
            replacement_fio,
         TO_CHAR (v.v_from, 'dd.mm.yyyy') v_from_t,
         TO_CHAR (v.v_to, 'dd.mm.yyyy') v_to_t
    FROM vacation v, user_list u, user_list u1
   WHERE     (v.replacement = :tn OR v.replacement_h_eta = :eta OR v.tn = :tn)
         AND SYSDATE BETWEEN v.v_from AND v.v_to + 1000
         AND u.tn = v.tn
         AND u1.tn(+) = v.replacement
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
ORDER BY v.v_from