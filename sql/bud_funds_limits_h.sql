/* Formatted on 15.01.2015 11:11:35 (QP5 v5.227.12220.39724) */
SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       TO_CHAR (dt, 'dd.mm.yyyy') dt,
       ok_traid,
       ok_traid_fio,
       TO_CHAR (ok_traid_lu, 'dd.mm.yyyy hh24:mi:ss') ok_traid_lu,
       ok_dpu,
       ok_dpu_fio,
       TO_CHAR (ok_dpu_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dpu_lu,
       dpt_id
  FROM bud_funds_limits_h
 WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy') AND dpt_id = :dpt_id and kk=:kk