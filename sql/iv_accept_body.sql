/* Formatted on 22/07/2015 10:57:35 (QP5 v5.227.12220.39724) */
  SELECT b.*, u.fio
    FROM iv_body b, user_list u
   WHERE b.iid = :id AND u.tn = b.tn
ORDER BY b.id