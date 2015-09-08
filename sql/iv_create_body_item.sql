/* Formatted on 21/04/2015 19:56:41 (QP5 v5.227.12220.39724) */
SELECT b.*, u.fio
  FROM iv_body b, user_list u
 WHERE b.id = :id AND u.tn = b.tn