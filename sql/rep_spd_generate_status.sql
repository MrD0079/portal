/* Formatted on 24/07/2015 12:52:21 (QP5 v5.227.12220.39724) */
SELECT dt, job
  FROM (SELECT COUNT (*) dt
          FROM rep_spd_dt
         WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy')),
       (SELECT COUNT (*) job
          FROM user_scheduler_jobs
         WHERE job_name = 'J_REP_SPD_GENERATE' AND state = 'RUNNING')