/* Formatted on 11.12.2014 23:23:04 (QP5 v5.227.12220.39724) */
  SELECT u.tn, u.fio
    FROM user_list u, p_plan p
   WHERE p.tn = u.tn AND p.test_count IS NOT NULL
ORDER BY u.fio