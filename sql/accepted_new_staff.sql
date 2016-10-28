/* Formatted on 11.01.2013 12:48:47 (QP5 v5.163.1008.3004) */
  SELECT n.fam,
         n.im,
         n.otch,
         TO_CHAR (n.datastart, 'dd.mm.yyyy') datastart,
         TO_CHAR (n.created, 'dd.mm.yyyy') created,
         TO_CHAR (n.accept_data, 'dd.mm.yyyy') accept_data,
         fn_getname ( n.creator) creator_name,
         (SELECT pos_name
            FROM pos
           WHERE pos_id = n.pos_id)
            pos_name
    FROM new_staff n
   WHERE     dpt_id = :dpt_id
         AND accepted = 1
         AND (n.creator IN (SELECT emp_tn
                              FROM (    SELECT LPAD (z.emp, LENGTH (z.emp) + (LEVEL) * 3, '-'), LEVEL, z.*
                                          FROM (SELECT fn_getname ( exp_tn) EXP,
                                                       fn_getname ( emp_tn) emp,
                                                       exp_tn,
                                                       emp_tn,
                                                       full
                                                  FROM emp_exp
                                                 WHERE full = 1 AND exp_tn <> emp_tn) z
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
         AND TRUNC (created) BETWEEN TO_DATE (:sd, 'dd.mm.yyyy') AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND DECODE (:pos_id, 0, NVL (pos_id, 0), :pos_id) = NVL (pos_id, 0)
ORDER BY ID