/* Formatted on 27/04/2015 17:07:20 (QP5 v5.227.12220.39724) */
  SELECT fio, tn, dpt_name
    FROM user_list
   WHERE     is_mkk = 1
         AND tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn)
         AND datauvol IS NULL
ORDER BY dpt_name, fio