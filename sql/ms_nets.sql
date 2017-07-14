/* Formatted on 2012/02/08 20:08 (Formatter Plus v4.8.8) */
SELECT   n.*,
         (SELECT fio
            FROM user_list
           WHERE tn = n.tn_tmkk)
            tmkk_name
    FROM ms_nets n
ORDER BY net_name