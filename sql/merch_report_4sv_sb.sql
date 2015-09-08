/* Formatted on 23.01.2015 11:54:52 (QP5 v5.227.12220.39724) */
  SELECT sbh.id,
         TO_CHAR (sbh.dt, 'dd.mm.yyyy') sb_dt,
         r.*,
         fn_getname ( r.rh_tn) svms_name,
         sbh.ok_ms,
         sbh.ok_kk,
         sbh.ok_ms_fio,
         TO_CHAR (sbh.ok_ms_lu, 'dd.mm.yyyy') ok_ms_lu,
         sbh.ok_kk_fio,
         TO_CHAR (sbh.ok_kk_lu, 'dd.mm.yyyy') ok_kk_lu,
         (SELECT COUNT (*)
            FROM mkk_oblast
           WHERE     oblast = r.cpp1_tz_oblast
                 AND tn IN (:tn, (SELECT parent
                                    FROM parents
                                   WHERE tn = :tn)))
            kk_can_ok
    FROM (SELECT DISTINCT rh_tn,
                          rh_data,
                          rh_id,
                          rb_kodtp,
                          n_net_name,
                          n_id_net,
                          cpp1_tz_oblast,
                          cpp1_city,
                          cpp1_tz_address
            FROM ms_rep_routes1) r,
         (SELECT *
            FROM merch_report_sb_head
           WHERE     DECODE (:ok_kk,
                             1, 0,
                             2, NVL (ok_kk, 0),
                             3, NVL (ok_kk, 0)) =
                        DECODE (:ok_kk,  1, 0,  2, 1,  3, 0)
                 AND DECODE (:ok_ms,
                             1, 0,
                             2, NVL (ok_ms, 0),
                             3, NVL (ok_ms, 0)) =
                        DECODE (:ok_ms,  1, 0,  2, 1,  3, 0)) sbh,
         (SELECT DISTINCT head_id, kod_tp, dt
            FROM merch_report_sb sb, merch_report_sb_comm comm, dimproduct d
           WHERE     sb.comm = comm.id
                 AND sb.product = d.product_id
                 AND sb.dt BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                               AND TO_DATE (:ed, 'dd.mm.yyyy')
                 AND DECODE (:vp, 0, 0, sb.product) = DECODE (:vp, 0, 0, :vp)) sb
   WHERE     r.rh_id = sbh.head_id
         AND r.rb_kodtp = sbh.kod_tp
         AND r.rh_data = TRUNC (sbh.dt, 'mm')
         AND sbh.head_id = sb.head_id
         AND sbh.kod_tp = sb.kod_tp
         AND sbh.dt = sb.dt
         AND DECODE (:tz, '0', '0', r.cpp1_tz_address) =
                DECODE (:tz, '0', '0', :tz)
         AND DECODE (:oblast, '0', '0', r.cpp1_tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', r.cpp1_city) =
                DECODE (:city, '0', '0', :city)
         AND DECODE (:nets, 0, 0, r.n_id_net) = DECODE (:nets, 0, 0, :nets)
         AND DECODE (:svms_list, 0, 0, r.rh_tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND (   r.rh_tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (   r.cpp1_tz_oblast IN (SELECT oblast
                                        FROM mkk_oblast
                                       WHERE tn IN (SELECT slave
                                                      FROM full
                                                     WHERE master = :tn))
              OR r.cpp1_tz_oblast IN (SELECT oblast
                                        FROM svms_oblast
                                       WHERE tn IN (SELECT slave
                                                      FROM full
                                                     WHERE master = :tn)))
ORDER BY sbh.dt,
         cpp1_tz_oblast,
         cpp1_city,
         cpp1_tz_address,
         svms_name