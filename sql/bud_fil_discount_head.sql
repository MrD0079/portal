/* Formatted on 05/01/2015 19:08:58 (QP5 v5.227.12220.39724) */
SELECT k.*,
       TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       TO_CHAR (dpu_lu, 'dd.mm.yyyy hh24:mi:ss') dpu_lu
  FROM bud_fil_discount_head k
 WHERE k.dt = TO_DATE (:sd, 'dd.mm.yyyy')