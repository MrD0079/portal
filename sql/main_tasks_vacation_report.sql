/* Formatted on 19.12.2013 16:51:08 (QP5 v5.227.12220.39724) */
SELECT COUNT (*)
  FROM vacation v, vacation_tasks t
 WHERE     (v.replacement = :tn OR v.replacement_h_eta = :eta)
       AND v.id = t.vac_id
       AND NVL (t.replacement_ok, 0) = 0
       AND SYSDATE BETWEEN v.v_from AND v.v_to + 1000
       AND NVL (v.vac_finished, 0) <> 1