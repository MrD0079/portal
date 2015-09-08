/* Formatted on 07.02.2014 15:32:23 (QP5 v5.227.12220.39724) */
DECLARE
   r   VARCHAR (255);
   c   INTEGER;
BEGIN
   FOR a1 IN (SELECT c.*, s.svideninn, s.creator
                FROM new_staff_childs c, new_staff s
               WHERE c.parent = :id AND c.parent = s.id)
   LOOP
      FOR a2 IN (SELECT *
                   FROM emp_exp
                  WHERE emp_tn = a1.tn AND full = 1)
      LOOP
         BEGIN
            SELECT fn_empexpdel (a2.emp_tn,a2.exp_tn)
              INTO r
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         BEGIN
            SELECT fn_emp_exp_ins (a2.emp_tn, a1.svideninn, 1)
              INTO r
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END LOOP;


      SELECT COUNT (*)
        INTO c
        FROM emp_exp
       WHERE emp_tn = a1.tn AND exp_tn = a1.creator;

      IF c = 0
      THEN
         BEGIN
            SELECT fn_emp_exp_ins (a1.tn, a1.creator, 0) INTO r FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
   END LOOP;

   COMMIT;
END;