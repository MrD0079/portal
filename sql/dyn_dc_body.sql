/* Formatted on 04.07.2012 10:01:37 (QP5 v5.163.1008.3004) */
           SELECT LEVEL,
                  oss.*,
                  LPAD (' ', (LEVEL - 1) * 5) || oss.name tree,
                  ob0.v_int d0_v_int,
                  ob0.v_text d0_v_text,
                  ob0.id d0_ob_id,
                  ob1.v_int d1_v_int,
                  ob1.v_text d1_v_text,
                  ob1.id d1_ob_id,
                  ob2.v_int d2_v_int,
                  ob2.v_text d2_v_text,
                  ob2.id d2_ob_id,
                  (    SELECT COUNT (*) c
                         FROM os_spr oss1
                   START WITH oss1.parent = oss.id
                   CONNECT BY PRIOR oss1.id = oss1.parent)
                     c,
                  (    SELECT COUNT (*) c
                         FROM os_spr oss1
                        WHERE LEVEL = 2
                   START WITH oss1.parent = oss.id
                   CONNECT BY PRIOR oss1.id = oss1.parent)
                     c1,
                  (SELECT SUM (v_int)
                     FROM os_body
                    WHERE spr_id IN (    SELECT id
                                           FROM os_spr oss1
                                     START WITH oss1.parent = oss.id
                                     CONNECT BY PRIOR oss1.id = oss1.parent)
                          AND head_id = (SELECT id
                                           FROM os_head
                                          WHERE tn = :tn AND y = :y))
                     en0,
                  (SELECT SUM (v_int)
                     FROM os_body
                    WHERE spr_id IN (    SELECT id
                                           FROM os_spr oss1
                                     START WITH oss1.parent = oss.id
                                     CONNECT BY PRIOR oss1.id = oss1.parent)
                          AND head_id = (SELECT id
                                           FROM os_head
                                          WHERE tn = :tn AND y = :y - 1))
                     en1,
                  (SELECT SUM (v_int)
                     FROM os_body
                    WHERE spr_id IN (    SELECT id
                                           FROM os_spr oss1
                                     START WITH oss1.parent = oss.id
                                     CONNECT BY PRIOR oss1.id = oss1.parent)
                          AND head_id = (SELECT id
                                           FROM os_head
                                          WHERE tn = :tn AND y = :y - 2))
                     en2
             FROM os_spr oss,
                  (SELECT *
                     FROM os_body
                    WHERE head_id = (SELECT id
                                       FROM os_head
                                      WHERE tn = :tn AND y = :y)) ob0,
                  (SELECT *
                     FROM os_body
                    WHERE head_id = (SELECT id
                                       FROM os_head
                                      WHERE tn = :tn AND y = :y - 1)) ob1,
                  (SELECT *
                     FROM os_body
                    WHERE head_id = (SELECT id
                                       FROM os_head
                                      WHERE tn = :tn AND y = :y - 2)) ob2
            WHERE     oss.id = ob0.spr_id(+)
                  AND oss.id = ob1.spr_id(+)
                  AND oss.id = ob2.spr_id(+)
       START WITH oss.parent = 0
       CONNECT BY PRIOR oss.id = oss.parent
ORDER SIBLINGS BY oss.sort