/* Formatted on 08/08/2014 11:59:51 (QP5 v5.227.12220.39724) */
  SELECT n.*,
         (SELECT status_name
            FROM nets_status
           WHERE ID = n.id_status)
            status_name,
         (SELECT fio
            FROM user_list
           WHERE tn = n.tn_rmkk)
            rmkk_name,
         (SELECT is_rmkk
            FROM user_list
           WHERE tn = n.tn_rmkk)
            is_rmkk,
         (SELECT fio
            FROM user_list
           WHERE tn = n.tn_mkk)
            mkk_name,
         (SELECT is_mkk
            FROM user_list
           WHERE tn = n.tn_mkk)
            is_mkk
    FROM nets n
   WHERE n.dpt_id = :dpt_id AND DECODE (:activ, 2, n.activ, :activ) = n.activ
ORDER BY net_name