/* Formatted on 18.04.2012 16:04:37 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_SCHEDULER.run_job (job_name              => 'J_GET_ACTIVITIES_DATA',
                           use_current_session   => FALSE);
END;