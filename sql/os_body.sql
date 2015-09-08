/* Formatted on 25.05.2012 11:19:42 (QP5 v5.163.1008.3004) */
           SELECT LEVEL,
                  oss.*,
                  LPAD (' ', (LEVEL - 1) * 5) || oss.name tree,
                  ob.v_int,
                  ob.v_text,
                  ob.id ob_id,
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
                     en
             FROM os_spr oss,
                  (SELECT *
                     FROM os_body
                    WHERE head_id = (SELECT id
                                       FROM os_head
                                      WHERE tn = :tn AND y = :y)) ob
            WHERE oss.id = ob.spr_id(+)
       START WITH oss.parent = 0
       CONNECT BY PRIOR oss.id = oss.parent
ORDER SIBLINGS BY oss.sort