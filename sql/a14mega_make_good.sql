/* Formatted on 12/17/2015 4:59:12  (QP5 v5.252.13127.32867) */
BEGIN
   DBMS_SCHEDULER.run_job (job_name              => 'J_A14MEGA_MAKE_GOOD',
                           use_current_session   => FALSE);
END;