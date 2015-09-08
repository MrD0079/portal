/* Formatted on 05/09/2014 15:38:51 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM nets
   WHERE dpt_id = :dpt_id AND activ = 1
ORDER BY net_name