/* Formatted on 10.02.2014 14:26:33 (QP5 v5.227.12220.39724) */
  SELECT u.tn, u.fio
    FROM user_list u, full f
   WHERE     f.full >= 0
         AND f.slave = u.tn
         AND f.master = :tn
         AND u.datauvol IS NULL
         AND u.is_db <> 1
ORDER BY u.fio