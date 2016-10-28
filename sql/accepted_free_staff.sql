/* Formatted on 12/10/2015 2:50:13  (QP5 v5.252.13127.32867) */
  SELECT n.id,fn_getname (n.tn) fio,
         TO_CHAR (n.datauvol, 'dd.mm.yyyy') datauvol,
         TO_CHAR (n.created, 'dd.mm.yyyy') created,
         TO_CHAR (n.accept_data, 'dd.mm.yyyy') accept_data,
         fn_getname (n.creator) creator_name,
         s.dolgn,
         (SELECT name
            FROM free_staff_seat
           WHERE id = n.seat)
            seat,
         n.params,
         n.fio_new,
         u.dpt_name
    FROM free_staff n, spdtree s, user_list u
   WHERE     s.svideninn = n.tn
         AND n.tn = u.tn
         AND s.dpt_id = u.dpt_id
         AND accepted = 1
         AND (   n.creator IN (SELECT emp_tn
                                 FROM (    SELECT LPAD (
                                                     z.emp,
                                                     LENGTH (z.emp) + (LEVEL) * 3,
                                                     '-'),
                                                  LEVEL,
                                                  z.*
                                             FROM (SELECT fn_getname (exp_tn) EXP,
                                                          fn_getname (emp_tn) emp,
                                                          exp_tn,
                                                          emp_tn,
                                                          full
                                                     FROM emp_exp
                                                    WHERE     full = 1
                                                          AND exp_tn <> emp_tn) z
                                       START WITH exp_tn = :tn
                                       CONNECT BY PRIOR emp_tn = exp_tn)
                               UNION
                               SELECT :tn FROM DUAL)
              OR (SELECT is_super
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_coach
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (   (    TRUNC (created) BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                          AND TO_DATE ( :ed, 'dd.mm.yyyy')
                  AND DECODE ( :pos_id, 0, NVL (s.pos_id, 0), :pos_id) =
                         NVL (s.pos_id, 0)
                  AND DECODE ( :seat, 0, NVL (n.seat, 0), :seat) =
                         NVL (n.seat, 0)
                  AND s.dpt_id = :dpt_id
				  AND LENGTH ( :staff_fio) IS NULL)
              OR (    LENGTH ( :staff_fio) > 0
                  AND LOWER (u.fio) LIKE '%' || LOWER(:staff_fio) || '%'))
ORDER BY n.ID