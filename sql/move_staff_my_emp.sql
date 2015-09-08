/* Formatted on 11.02.2014 15:50:12 (QP5 v5.227.12220.39724) */
  SELECT u.tn, u.fio, u.pos_name
    FROM user_list u, full f
   WHERE     f.full >= 0
         AND f.slave = u.tn
         AND f.master = :tn
         AND u.datauvol IS NULL
ORDER BY u.fio