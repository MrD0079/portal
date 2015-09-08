/* Formatted on 21.10.2014 19:34:02 (QP5 v5.227.12220.39724) */
SELECT k.*, TO_CHAR (ok_dpu_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dpu_lu
  FROM kcm k
 WHERE k.dt = TO_DATE (:sd, 'dd.mm.yyyy')
and dpt_id=:dpt_id