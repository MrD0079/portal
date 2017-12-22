/* Formatted on 22.12.2017 21:47:50 (QP5 v5.252.13127.32867) */
  SELECT n.id_net,
         n.net_name,
         m.y || '.' || c.mt period,
         m.y,
         m.m,
         fn_getname (n.tn_rmkk) "nmkk",
         fn_getname (n.tn_mkk) "tmkk",
         m.kod_filial,
         bf.id fil_id,
         bf.name fil_name,
         SUM (NVL (m.summa, 0)) fakt,
         SUM (NVL (m.summa, 0)) * 0.3 fakt03,
         SUM (NVL (m.summa, 0) - NVL (m.summskidka, 0)) price,
         SUM (NVL (m.summa, 0)) * 0.3 - NVL (iu.comission_sum, 0) remain,
         iu.link_costs,
         iu.ok_tm,
         iu.ok_fm,
         iu.comission_sum,
         iu.deviation_comm,
         iu.fn
    FROM nets n
         JOIN tp_nets_kk nk ON n.sw_kod = nk.net_kod
         JOIN a14mega m ON nk.tp_kod = m.tp_kod
         JOIN (SELECT DISTINCT my, mt FROM calendar) c ON m.m = c.my
         JOIN bud_fil bf ON m.kod_filial = bf.sw_kod
         LEFT JOIN invoice_reestr_up iu
            ON     m.m = iu.m
               AND m.y = iu.y
               AND bf.id = iu.fil_id
               AND n.id_net = iu.id_net
   WHERE     m.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                      AND TO_DATE ( :ed, 'dd.mm.yyyy')
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
         AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
         AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
         AND (   DECODE ( :okfm, 'all', 0) = 0
              OR DECODE ( :okfm, 'no', 0) = NVL (iu.ok_fm, 0)
              OR DECODE ( :okfm, 'ok', 1) = NVL (iu.ok_fm, 0))
         AND (   DECODE ( :oktm, 'all', 0) = 0
              OR DECODE ( :oktm, 'no', 0) = NVL (iu.ok_tm, 0)
              OR DECODE ( :oktm, 'ok', 1) = NVL (iu.ok_tm, 0))
/*AND n.id_net = 130267636*/
GROUP BY n.id_net,
         n.net_name,
         n.tn_rmkk,
         n.tn_mkk,
         m.kod_filial,
         bf.name,
         m.y,
         c.my,
         c.mt,
         m.m,
         bf.id,
         iu.link_costs,
         iu.ok_tm,
         iu.ok_fm,
         iu.comission_sum,
         iu.deviation_comm,
         m.dt,
         iu.fn
ORDER BY n.net_name, fil_name, m.dt