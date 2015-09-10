/* Formatted on 18/05/2015 14:56:17 (QP5 v5.227.12220.39724) */
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
                 (SELECT val_list
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND admin_id = 4)
                         AND z_id = z1.id)
                    tp_kod,
                 (SELECT val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v4')
                         AND z_id = z1.id)
                    z_v4,
                 (SELECT rep_val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv4')
                         AND z_id = z1.id)
                    z_rv4,
                 (SELECT val_bool
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND admin_id = 8)
                         AND z_id = z1.id)
                    z_adminid8,
                 (SELECT val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v15')
                         AND z_id = z1.id)
                    z_v15,
                 (SELECT rep_val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv15')
                         AND z_id = z1.id)
                    z_rv15,
                 (SELECT val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v16')
                         AND z_id = z1.id)
                    z_v16,
                 (SELECT rep_val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv16')
                         AND z_id = z1.id)
                    z_rv16,
                 (SELECT val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v17')
                         AND z_id = z1.id)
                    z_v17,
                 (SELECT rep_val_number * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv17')
                         AND z_id = z1.id)
                    z_rv17,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v18')
                         AND z_id = z1.id)
                    z_v18,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv18')
                         AND z_id = z1.id)
                    z_rv18,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v19')
                         AND z_id = z1.id)
                    z_v19,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv19')
                         AND z_id = z1.id)
                    z_rv19,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v20')
                         AND z_id = z1.id)
                    z_v20,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv20')
                         AND z_id = z1.id)
                    z_rv20,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v21')
                         AND z_id = z1.id)
                    z_v21,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv21')
                         AND z_id = z1.id)
                    z_rv21,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v22')
                         AND z_id = z1.id)
                    z_v22,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv22')
                         AND z_id = z1.id)
                    z_rv22,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v23')
                         AND z_id = z1.id)
                    z_v23,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv23')
                         AND z_id = z1.id)
                    z_rv23,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v24')
                         AND z_id = z1.id)
                    z_v24,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv24')
                         AND z_id = z1.id)
                    z_rv24,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v25')
                         AND z_id = z1.id)
                    z_v25,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv25')
                         AND z_id = z1.id)
                    z_rv25,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v26')
                         AND z_id = z1.id)
                    z_v26,
                 (SELECT rep_val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE     dpt_id = :dpt_id
                                        AND rep_var_name = 'rv26')
                         AND z_id = z1.id)
                    z_rv26,
                 (SELECT val_bool
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND admin_id = 370)
                         AND z_id = z1.id)
                    z_adminid370,
                 (SELECT val_bool
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN (SELECT id
                                         FROM bud_ru_ff
                                        WHERE dpt_id = :dpt_id AND var1 = 370)
                         AND z_id = z1.id)
                    z_var1370,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v27')
                         AND z_id = z1.id)
                    z_v27,
                 (SELECT val_number_int * 1
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN
                                (SELECT id
                                   FROM bud_ru_ff
                                  WHERE dpt_id = :dpt_id AND var_name = 'v28')
                         AND z_id = z1.id)
                    z_v28
            FROM bud_ru_zay z1
           WHERE     z1.valid_no = 0
                 AND z1.st = 19534553
                 AND z1.dt_start BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                     AND TO_DATE (:ed, 'dd.mm.yyyy')
                 AND (SELECT rep_accepted
                        FROM bud_ru_zay_accept
                       WHERE     z_id = z1.id
                             AND accept_order =
                                    DECODE (
                                       NVL (
                                          (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z1.id
                                                  AND rep_accepted = 2),
                                          0),
                                       0, (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z1.id
                                                  AND rep_accepted IS NOT NULL),
                                       (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE     z_id = z1.id
                                               AND rep_accepted = 2))) =
                        1
                 AND DECODE ( (SELECT COUNT (*)
                                 FROM bud_ru_zay_accept
                                WHERE z_id = z1.id AND rep_accepted = 2),
                             0, 0,
                             1) = 0
                 AND DECODE (:fil, 0, z1.fil, :fil) = z1.fil
                 AND (   z1.fil IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)) zay
   WHERE     m.tab_number = u1.tab_num
         AND u1.dpt_id = :dpt_id
         AND p.tn = u1.tn
         AND p.parent = pu.tn
         AND m.tp_kod = zay.tp_kod
         AND u1.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND u1.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (   u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:eta_list, '', m.h_eta, :eta_list) = m.h_eta
         AND pu.tn = DECODE (:db, 0, pu.tn, :db)
         AND DECODE (:adminid8,  1, zay.z_adminid8,  2, 1,  3, 0) =
                zay.z_adminid8
ORDER BY pu.fio,
         u1.fio,
         m.eta,
         m.tp_name