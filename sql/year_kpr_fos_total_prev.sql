/* Formatted on 11.01.2013 13:56:45 (QP5 v5.163.1008.3004) */
SELECT SUM (total) total
  FROM (  SELECT sc.my, sc.mt, SUM (NVL (fou.total, 0)) total
            FROM (SELECT DISTINCT y, my, mt
                    FROM calendar
                   WHERE y = :y AND my < EXTRACT (MONTH FROM SYSDATE)) sc,
                 (  SELECT SUM (m.summa) total, EXTRACT (YEAR FROM m.oplata_date) y, EXTRACT (MONTH FROM m.oplata_date) m
                      FROM invoice m, nets n
                     WHERE     m.id_net = n.id_net
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
                                                  WHERE tn = :tn AND is_super = 1), :tn,
                                        (SELECT pos_id
                                           FROM user_list
                                          WHERE tn = :tn AND is_admin = 1), :tn))
                           AND DECODE (:net, 0, n.id_net, :net) = n.id_net
                           AND (n.id_net IN (SELECT kk_flt_nets_detail.id_net
                                               FROM kk_flt_nets, kk_flt_nets_detail
                                              WHERE kk_flt_nets.id = :flt_id AND kk_flt_nets.id = kk_flt_nets_detail.id_flt)
                                OR :flt_id = 0)
                           AND DECODE (:tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                           AND DECODE (:tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                           AND EXTRACT (YEAR FROM m.oplata_date) = :y
                           AND M.OPLACHEN = 1
                  GROUP BY EXTRACT (YEAR FROM m.oplata_date), EXTRACT (MONTH FROM m.oplata_date)) fou
           WHERE sc.y = fou.y(+) AND sc.my = fou.m(+)
        GROUP BY sc.y, sc.my, sc.mt)