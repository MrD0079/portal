/* Formatted on 30.04.2014 9:18:58 (QP5 v5.227.12220.39724) */
           SELECT LEVEL,
                  os_ac_s.*,
                  (SELECT parent
                     FROM OS_AC_spr
                    WHERE id = os_ac_s.parent)
                     parent1,
                  LPAD (' ', (LEVEL - 1) * 5) || os_ac_s.name tree,
                  ob.v_int,
                  ob.v_text,
                  ob.id ob_id,
                  (    SELECT COUNT (*) c
                         FROM OS_AC_spr os_ac_s1
                   START WITH os_ac_s1.parent = os_ac_s.id
                   CONNECT BY PRIOR os_ac_s1.id = os_ac_s1.parent)
                     c,
                  (    SELECT COUNT (*) c
                         FROM OS_AC_spr os_ac_s1
                        WHERE LEVEL = 2
                   START WITH os_ac_s1.parent = os_ac_s.id
                   CONNECT BY PRIOR os_ac_s1.id = os_ac_s1.parent)
                     c1,
                  (SELECT SUM (v_int)
                     FROM OS_AC_body
                    WHERE     spr_id IN (    SELECT id
                                               FROM OS_AC_spr os_ac_s1
                                         START WITH os_ac_s1.parent = os_ac_s.id
                                         CONNECT BY PRIOR os_ac_s1.id = os_ac_s1.parent)
                          AND head_id =
                                 (SELECT id
                                    FROM OS_AC_head
                                   WHERE     ac_memb_id = :ac_memb_id
                                         AND ac_memb_type = :ac_memb_type))
                     en
             FROM OS_AC_spr os_ac_s,
                  (SELECT *
                     FROM OS_AC_body
                    WHERE head_id =
                             (SELECT id
                                FROM OS_AC_head
                               WHERE     ac_memb_id = :ac_memb_id
                                     AND ac_memb_type = :ac_memb_type)) ob
            WHERE os_ac_s.id = ob.spr_id(+)
       START WITH os_ac_s.parent = 0
       CONNECT BY PRIOR os_ac_s.id = os_ac_s.parent
ORDER SIBLINGS BY os_ac_s.sort