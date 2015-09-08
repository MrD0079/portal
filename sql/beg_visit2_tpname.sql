/* Formatted on 25.03.2014 15:57:14 (QP5 v5.227.12220.39724) */
SELECT DISTINCT tp_name,
                address,
                tp_type,
                eta
  FROM routes
 WHERE tp_kod = (SELECT tp_kod
                   FROM beg_visit_head
                  WHERE id = :head)