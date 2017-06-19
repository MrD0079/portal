/* Formatted on 06/06/2016 14:01:13 (QP5 v5.252.13127.32867) */
  SELECT s.fil,
         s.fname,
         s.summa,
         DECODE (sv.net_kod, NULL, NULL, 1) selected,
         NVL (sv.fixed_fakt, 0) fixed_fakt,
         NVL (sv.bonus_fakt, 0) bonus_fakt,
         NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
         sv.cash,
           (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
         * CASE WHEN NVL (sv.cash, 0) = 1 THEN 1 ELSE s.compens_distr_koef END
            compens_distr,
         sv.lu_fio,
         TO_CHAR (sv.lu, 'dd.mm.yyyy hh24:mi:ss') lu
    FROM (  SELECT tpn.net,
                   tpn.net_kod,
                   p.parent db,
                   f.id fil,
                   f.name fname,
                   SUM (m.summa) summa,
                     (  1
                      -   NVL (
                             (SELECT discount
                                FROM bud_fil_discount_body
                               WHERE     dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                                     AND distr = f.id),
                             0)
                        / 100)
                   * (SELECT bonus_log_koef
                        FROM bud_fil
                       WHERE id = f.id)
                      compens_distr_koef
              FROM a14mega m,
                   user_list u,
                   parents p,
                   tp_nets tpn,
                   bud_fil f,
                   bud_tn_fil tf,
                   bud_svod_zp zp
             WHERE     m.tp_kod = tpn.tp_kod
                   AND u.tn = p.tn
                   AND m.dpt_id = :dpt_id
                   AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt
                   AND u.tab_num = m.tab_num
                   AND u.dpt_id = m.dpt_id
                   AND f.id = tf.bud_id
                   AND tf.tn = p.parent
                   AND f.dpt_id = m.dpt_id
                   AND (   f.data_end IS NULL
                        OR TRUNC (f.data_end, 'mm') >=
                              TO_DATE ( :dt, 'dd.mm.yyyy'))
                   AND zp.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                   AND zp.dpt_id = :dpt_id
                   AND zp.fil IS NOT NULL
                   AND zp.h_eta = m.h_eta
                   AND f.id = zp.fil(+)
                   AND tpn.net_kod = :net_kod
                   AND p.parent = :db
                   AND (   :exp_list_without_ts = 0
                        OR u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :exp_list_without_ts))
                   AND (   :exp_list_only_ts = 0
                        OR u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :exp_list_only_ts))
                and u.is_spd=1
   AND (   u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                        OR (SELECT NVL (is_traid, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1
                        OR (SELECT NVL (is_traid_kk, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1)
                   AND (:eta_list is null OR :eta_list = m.h_eta)
                   AND (f.id = :fil OR :fil = 0)
                   AND (   f.id IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                        OR :clusters = 0)
          GROUP BY tpn.net,
                   tpn.net_kod,
                   p.parent,
                   f.id,
                   f.name) s,
         sc_svodn sv
   WHERE     s.net_kod = sv.net_kod(+)
         AND s.net_kod = :net_kod
         AND s.fil = sv.fil(+)
         AND s.db = sv.db(+)
         AND s.db = :db
         AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt(+)
         AND :dpt_id = sv.dpt_id(+)
         AND DECODE ( :ok_bonus,  1, 0,  2, sv.net_kod) =
                DECODE ( :ok_bonus,  1, 0,  2, NVL (sv.net_kod, 0))
ORDER BY s.fname