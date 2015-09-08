/* Formatted on 09/12/2013 9:23:36 (QP5 v5.227.12220.39724) */
DECLARE
   r   VARCHAR2 (255);
BEGIN
   FOR a
      IN (SELECT e.*
            FROM emp_exp e, user_list u
           WHERE e.exp_tn = :tn AND u.tn = e.emp_tn AND u.dpt_id = :dpt_id)
   LOOP
      SELECT fn_empexpdel (a.emp_tn,a.exp_tn)
        INTO r
        FROM DUAL;
   END LOOP;
END;