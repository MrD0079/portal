/* Formatted on 15/04/2015 18:29:47 (QP5 v5.227.12220.39724) */
  SELECT b.*,to_char(b.mz,'dd.mm.yyyy') mz
    FROM bonus_body b
   WHERE bonus_id=:id
ORDER BY id