/* Formatted on 27/05/2015 13:24:30 (QP5 v5.227.12220.39724) */
SELECT k.*,
       TO_CHAR (ok_ndp_lu, 'dd.mm.yyyy hh24:mi:ss') ok_ndp_lu,
       TO_CHAR (ok_dpu_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dpu_lu
  FROM advance_ok k
 WHERE k.m = TO_DATE (:sd, 'dd.mm.yyyy') AND dpt_id = :dpt_id