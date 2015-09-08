/* Formatted on 15.01.2015 11:27:11 (QP5 v5.227.12220.39724) */
  SELECT f.id, f.name
    FROM bud_funds f
   WHERE f.dpt_id = :dpt_id AND f.planned = 1
ORDER BY f.name