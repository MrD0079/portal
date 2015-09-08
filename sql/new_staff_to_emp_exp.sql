/* Formatted on 11.01.2013 13:29:15 (QP5 v5.163.1008.3004) */
DECLARE
   a   VARCHAR (255);
BEGIN
   BEGIN
      SELECT fn_emp_exp_ins (svideninn, svideninn, 0)
        INTO a
        FROM new_staff
       WHERE ID = :ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   BEGIN
      SELECT fn_emp_exp_ins (svideninn, creator, 1)
        INTO a
        FROM new_staff
       WHERE ID = :ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   BEGIN
      SELECT fn_emp_exp_ins (svideninn, bt, 0)
        INTO a
        FROM new_staff
       WHERE ID = :ID AND NVL (bt, 0) <> 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   BEGIN
      SELECT fn_emp_exp_ins (svideninn,
                             (SELECT exp_tn
                                FROM emp_exp
                               WHERE FULL = 1 AND emp_tn = ns.creator AND ROWNUM = 1),
                             0)
        INTO a
        FROM new_staff ns
       WHERE ID = :ID;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   COMMIT;
END;