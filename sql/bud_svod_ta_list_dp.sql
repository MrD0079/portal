/* Formatted on 17/02/2015 19:54:26 (QP5 v5.227.12220.39724) */
SELECT ok_dp_tn,
       TO_CHAR (ok_dp_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dp_lu,
       ok_dp_fio
  FROM bud_svod_tam
 WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')