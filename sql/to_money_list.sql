/* Formatted on 07.11.2017 20:15:14 (QP5 v5.252.13127.32867) */
  SELECT pu.tn chief_tn,
         pu.fio chief_fio,
         u1.tn ts_tn,
         u1.fio ts_fio,
         m.*,
         zay.*
    FROM (SELECT DISTINCT h_eta,
                          eta,
                          tp_kod,
                          tp_type,
                          tp_name,
                          address,
                          tab_number
            FROM routes
           WHERE dpt_id = :dpt_id) m,
         user_list u1,
         user_list pu,
         parents p,
         (SELECT (SELECT name
                    FROM bud_fil
                   WHERE id = z1.fil)
                    filname,
                 TRUNC (z1.dt_start, 'mm') period,
                 z1.id,
                 TO_CHAR (z1.created, 'dd.mm.yyyy hh24:mi:ss') created,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'admin_id', 4)), 0)
                    tp_kod,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v4')), 0)
                    z_v4,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv4')),
                      0)
                    z_rv4,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'admin_id', 8)), 0)
                    z_adminid8,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v15')), 0)
                    z_v15,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v16')), 0)
                    z_v16,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v17')), 0)
                    z_v17,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v18')), 0)
                    z_v18,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v19')), 0)
                    z_v19,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v20')), 0)
                    z_v20,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v21')), 0)
                    z_v21,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v22')), 0)
                    z_v22,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v23')), 0)
                    z_v23,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v24')), 0)
                    z_v24,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v25')), 0)
                    z_v25,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v26')), 0)
                    z_v26,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v27')), 0)
                    z_v27,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'var_name', 'v28')), 0)
                    z_v28,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv15')),
                      0)
                    z_rv15,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv16')),
                      0)
                    z_rv16,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv17')),
                      0)
                    z_rv17,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv18')),
                      0)
                    z_rv18,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv19')),
                      0)
                    z_rv19,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv20')),
                      0)
                    z_rv20,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv21')),
                      0)
                    z_rv21,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv22')),
                      0)
                    z_rv22,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv23')),
                      0)
                    z_rv23,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv24')),
                      0)
                    z_rv24,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv25')),
                      0)
                    z_rv25,
                 NVL (TO_NUMBER (getZayFieldVal (z1.id, 'rep_var_name', 'rv26')),
                      0)
                    z_rv26,
                 NVL (kat.tu, 0) tu
            FROM bud_ru_zay z1, BUD_RU_st_ras kat
           WHERE     z1.valid_no = 0
                 AND z1.st = 19534553
                 AND z1.kat = kat.id(+)
                 AND z1.dt_start BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                     AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND (SELECT rep_accepted
                        FROM bud_ru_zay_accept
                       WHERE     z_id = z1.id
                             AND INN_not_ReportMA (tn) = 0
                             AND accept_order =
                                    DECODE (
                                       NVL (
                                          (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z1.id
                                                  AND rep_accepted = 2
                                                  AND INN_not_ReportMA (tn) = 0),
                                          0),
                                       0, (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z1.id
                                                  AND rep_accepted IS NOT NULL
                                                  AND INN_not_ReportMA (tn) = 0),
                                       (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE     z_id = z1.id
                                               AND rep_accepted = 2
                                               AND INN_not_ReportMA (tn) = 0))) =
                        1
                 AND DECODE (
                        (SELECT COUNT (*)
                           FROM bud_ru_zay_accept
                          WHERE     z_id = z1.id
                                AND rep_accepted = 2
                                AND INN_not_ReportMA (tn) = 0),
                        0, 0,
                        1) = 0
                 AND DECODE ( :fil, 0, z1.fil, :fil) = z1.fil
                 AND (   z1.fil IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)) zay
   WHERE     m.tab_number = u1.tab_num
         AND u1.dpt_id = :dpt_id
         AND u1.is_spd = 1
         AND p.tn = u1.tn
         AND p.parent = pu.tn
         AND m.tp_kod = zay.tp_kod
         AND (   :exp_list_without_ts = 0
              OR u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
              OR u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :exp_list_only_ts))
         AND (   u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ( :eta_list IS NULL OR :eta_list = m.h_eta)
         AND pu.tn = DECODE ( :db, 0, pu.tn, :db)
         AND DECODE ( :adminid8,  1, zay.z_adminid8,  2, 1,  3, 0) =
                zay.z_adminid8
ORDER BY pu.fio,
         u1.fio,
         m.eta,
         m.tp_name