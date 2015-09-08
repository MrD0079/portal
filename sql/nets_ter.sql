/* Formatted on 11.01.2013 13:28:47 (QP5 v5.163.1008.3004) */
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
            is_mkk,
         (SELECT DECODE (n.tn_mkk - :tn, 0, 0, DECODE (COUNT (*), 0, 0, 1))
            FROM nets_plan_month
           WHERE mkk_ter = :tn AND id_net = n.id_net)
            ter_mkk,
         (SELECT DECODE (n.tn_rmkk - :tn, 0, 0, DECODE (COUNT (*), 0, 0, 1))
            FROM nets_plan_month
           WHERE mkk_ter IN (SELECT tn_mkk
                               FROM nets
                              WHERE tn_rmkk = :tn)
                 AND id_net = n.id_net)
            ter_rmkk
    FROM nets n
   WHERE    :tn IN (DECODE ( (SELECT pos_id
                                 FROM spdtree
                                WHERE svideninn = :tn),
                             24, n.tn_mkk,
                             34, n.tn_rmkk,
                             63, :tn,
                             65, :tn,
                             67, :tn,
                             (SELECT pos_id
                                FROM user_list
                               WHERE tn = :tn AND (is_super = 1 OR is_admin = 1)), :tn))
         OR :tn IN (SELECT mkk_ter
                       FROM nets_plan_month
                      WHERE id_net = n.id_net)
         OR :tn IN (SELECT tn_rmkk
                       FROM nets
                      WHERE tn_mkk IN (SELECT mkk_ter
                                         FROM nets_plan_month
                                        WHERE id_net = n.id_net))
ORDER BY net_name