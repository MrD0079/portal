/* Formatted on 09/04/2015 12:57:29 (QP5 v5.227.12220.39724) */
BEGIN
   INSERT INTO persik.p_prob_inst (prob_tn,
                                   inst_tn,
                                   data_start,
                                   data_end,
                                   chief_tn,
                                   dir_tn)
      SELECT svideninn,
             creator,
             datastart,
             datastart + 91,
             bt,
             (SELECT exp_tn
                FROM emp_exp
               WHERE FULL = 1 AND emp_tn = ns.creator AND ROWNUM = 1)
        FROM new_staff ns
       WHERE ID = :ID;

   COMMIT;
END;