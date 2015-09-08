/* Formatted on 15.02.2014 20:35:30 (QP5 v5.227.12220.39724) */
  SELECT f.*
    FROM merch_chat c, merch_chat_f f
   WHERE     c.id = f.chat_id
         AND c.dt = TO_DATE (:dt, 'dd.mm.yyyy')
         AND c.ag_id = :ag_id
         AND kod_tp = :kod_tp
ORDER BY f.fn