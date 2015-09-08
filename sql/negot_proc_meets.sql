/* Formatted on 11.01.2013 13:27:13 (QP5 v5.163.1008.3004) */
  SELECT n.id_net,
         my.ID,
         my.meet_file,
         my.meet_file_name,
         TO_CHAR (my.meet_date, 'dd.mm.yyyy') meet_date,
         TO_CHAR (my.meet_date_next, 'dd.mm.yyyy') meet_date_next,
         my.manager,
         fn_getname ( my.manager) manager_fio
    FROM nets n, nets_meetings_year my
   WHERE     :y = my.YEAR
         AND n.id_net = my.id_net
         AND :tn IN (DECODE ( (SELECT pos_id
                                  FROM spdtree
                                 WHERE svideninn = :tn),
                              24, n.tn_mkk,
                              34, n.tn_rmkk,
                              63, :tn,
                              65, :tn,
                              67, :tn,
                              (SELECT pos_id
                                 FROM user_list
                                WHERE tn = :tn AND is_super = 1), :tn))
         AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
ORDER BY my.meet_date, my.meet_date_next