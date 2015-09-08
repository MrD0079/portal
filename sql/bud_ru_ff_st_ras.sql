/* Formatted on 07.11.2013 16:52:29 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM bud_ru_st_ras
   WHERE parent = 0 AND dpt_id = :dpt_id
ORDER BY sort, name