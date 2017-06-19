/* Formatted on 07/04/2015 12:05:45 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist, NVL (SUM (visible), 0) visible
  FROM (SELECT m.tp_kod,
               CASE
                  WHEN    u1.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                       OR (SELECT NVL (is_traid, 0)
                             FROM user_list
                            WHERE tn = :tn) = 1
                       OR (SELECT NVL (is_traid_kk, 0)
                             FROM user_list
                            WHERE tn = :tn) = 1
                  THEN
                     1
               END
                  visible
          FROM bud_svod_zp zp,
               a14mega m,
               departments d,
               user_list u1
         WHERE     zp.dt BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                             AND TO_DATE (:ed, 'dd.mm.yyyy')
               AND zp.dpt_id = :dpt_id
               AND zp.fil IS NOT NULL
               AND zp.h_eta = m.h_eta
               AND zp.dt = m.dt
               AND m.tab_num = u1.tab_num
               AND u1.dpt_id = :dpt_id
           and u1.is_spd=1
    AND DECODE (:tp_kod, 0, m.tp_kod, :tp_kod) = m.tp_kod
               AND d.manufak = m.country
               AND d.dpt_id = :dpt_id)