/* Formatted on 19/11/2014 11:45:56 (QP5 v5.227.12220.39724) */
  SELECT m.*, TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_txt
    FROM kcm_chat m
   WHERE m.dt = TO_DATE (:sd, 'dd.mm.yyyy') AND dpt_id = :dpt_id
ORDER BY id