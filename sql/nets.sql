/* Formatted on 13/08/2014 11:44:28 (QP5 v5.227.12220.39724) */
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
   WHERE     :tn IN
                (DECODE (
                    (SELECT pos_id
                       FROM spdtree
                      WHERE svideninn = :tn),
                    24, n.tn_mkk,
                    34, n.tn_rmkk,
                    63, :tn,
                    65, :tn,
                    67, :tn,
                    (SELECT pos_id
                       FROM user_list
                      WHERE tn = :tn AND (is_super = 1 OR is_fin_man = 1 OR is_admin = 1)), :tn,
                    :tn))
         AND dpt_id = :dpt_id
ORDER BY net_name