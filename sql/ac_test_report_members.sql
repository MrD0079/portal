/* Formatted on 15/09/2014 11:26:48 (QP5 v5.227.12220.39724) */
  SELECT m.*, tl.name name_logic, tm.name name_math
    FROM (SELECT i.id,
                 u.fio,
                 u.e_mail mail,
                 'int' ie,
                 'внутренний' iet,
                 u.pos_name,
                 i.ac_test_logic,
                 i.ac_test_math,
                 NULL login,
                 NULL password,
                 i.logic_test,
                 i.math_test
            FROM ac_memb_int i, user_list u
           WHERE i.ac_id = :id AND u.tn = i.tn
          UNION
          SELECT i.id,
                 i.fam || ' ' || i.im || ' ' || i.otch fio,
                 i.email mail,
                 'ext' ie,
                 'внешний' iet,
                 NULL,
                 i.ac_test_logic,
                 i.ac_test_math,
                 i.login,
                 u.password,
                 i.logic_test,
                 i.math_test
            FROM ac_memb_ext i, user_list u
           WHERE i.ac_id = :id AND i.login = u.login(+)) m,
         ac_test tl,
         ac_test tm
   WHERE m.ac_test_logic = tl.id(+) AND m.ac_test_math = tm.id(+)
ORDER BY m.ie, m.fio