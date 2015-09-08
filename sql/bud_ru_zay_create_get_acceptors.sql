/* Formatted on 21.10.2013 14:05:56 (QP5 v5.227.12220.39724) */
  SELECT u.fio acceptor
    FROM bud_ru_zay_accept a, user_list u
   WHERE a.z_id = :id AND a.tn = u.tn
ORDER BY a.accept_order