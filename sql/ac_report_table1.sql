/* Formatted on 16.09.2014 12:02:04 (QP5 v5.227.12220.39724) */
  SELECT m.*,
         os.block_id,
         os.block_name,
         os.block_sort,
         os.c1,
         os.en
    FROM (SELECT i.id,
                 u.fio,
                 u.e_mail mail,
                 i.memb_int_order sort,
                 'int' ie,
                 'внутренний' iet,
                 i.ac_id,
                 NULL resume
            FROM ac_memb_int i, user_list u
           WHERE i.ac_id = :id AND u.tn = i.tn
          UNION
          SELECT i.id,
                 i.fam || ' ' || i.im || ' ' || i.otch fio,
                 i.email mail,
                 i.memb_ext_order sort,
                 'ext' ie,
                 'внешний' iet,
                 i.ac_id,
                 i.resume
            FROM ac_memb_ext i
           WHERE i.ac_id = :id) m,
         (    SELECT os_ac_s.id block_id,
                     os_ac_s.name block_name,
                     os_ac_s.sort block_sort,
                     (    SELECT COUNT (*) c
                            FROM OS_AC_spr os_ac_s1
                           WHERE LEVEL = 2
                      START WITH os_ac_s1.parent = os_ac_s.id
                      CONNECT BY PRIOR os_ac_s1.id = os_ac_s1.parent)
                        c1,
                     (SELECT SUM (v_int)
                        FROM OS_AC_body
                       WHERE     spr_id IN
                                    (    SELECT id
                                           FROM OS_AC_spr os_ac_s1
                                     START WITH os_ac_s1.parent = os_ac_s.id
                                     CONNECT BY PRIOR os_ac_s1.id = os_ac_s1.parent)
                             AND head_id =
                                    (SELECT id
                                       FROM OS_AC_head
                                      WHERE     ac_memb_id = h.ac_memb_id
                                            AND ac_memb_type = h.ac_memb_type))
                        en,
                     h.ac_memb_id
                FROM OS_AC_spr os_ac_s, OS_AC_head h
               WHERE LEVEL = 1
          START WITH os_ac_s.parent = 0
          CONNECT BY PRIOR os_ac_s.id = os_ac_s.parent
          UNION
          SELECT r.test_id block_id,
                 r.test_name block_name,
                 r.block_sort block_sort,
                 r.c1,
                 r.ball en,
                 r.memb_id ac_memb_id
            FROM (SELECT id memb_id,
                         999999999999991 test_id,
                         logic_test_ball ball,
                         'Тест Логика' test_name,
                         999999999999991 block_sort,
                         (SELECT COUNT (*)
                            FROM ac_test
                           WHERE parent = ac_test_logic)
                            c1
                    FROM ac_memb_ext
                   WHERE logic_test = 2
                  UNION
                  SELECT id memb_id,
                         999999999999991 test_id,
                         logic_test_ball ball,
                         'Тест Логика' test_name,
                         999999999999991 block_sort,
                         (SELECT COUNT (*)
                            FROM ac_test
                           WHERE parent = ac_test_logic)
                            c1
                    FROM ac_memb_int
                   WHERE logic_test = 2
                  UNION
                  SELECT id memb_id,
                         999999999999992 test_id,
                         math_test_ball ball,
                         'Тест Математика' test_name,
                         999999999999992 block_sort,
                         (SELECT COUNT (*)
                            FROM ac_test
                           WHERE parent = ac_test_math)
                            c1
                    FROM ac_memb_ext
                   WHERE math_test = 2
                  UNION
                  SELECT id memb_id,
                         999999999999992 test_id,
                         math_test_ball ball,
                         'Тест Математика' test_name,
                         999999999999992 block_sort,
                         (SELECT COUNT (*)
                            FROM ac_test
                           WHERE parent = ac_test_math)
                            c1
                    FROM ac_memb_int
                   WHERE math_test = 2) r) os
   WHERE m.id = os.ac_memb_id(+)
ORDER BY m.fio, os.block_sort