/* Formatted on 22.10.2017 14:32:42 (QP5 v5.252.13127.32867) */
  SELECT current_status,
         (SELECT name1
            FROM accept_types
           WHERE id = z.current_status)
            current_status_txt,
         SUM (DECODE (full, -2, 1, 0)) full2,
         SUM (DECODE (full, 1, 1, 0)) + SUM (DECODE (full, 0, 1, 0)) full01,
         COUNT (*) c,
         TO_CHAR (MIN (created_dt), 'dd.mm.yyyy') min_dt,
         TO_CHAR (MAX (created_dt), 'dd.mm.yyyy') max_dt
    FROM (SELECT DISTINCT z.id,
                          NVL (current_accepted_id, 0) current_status,
                          NVL ( (SELECT full
                                   FROM full
                                  WHERE master = :tn AND slave = z.creator_tn),
                               0)
                             full,
                          z.created_dt
            FROM (SELECT z.id,
                         TO_CHAR (z.created, 'dd.mm.yyyy hh24:mi:ss') created,
                         TO_CHAR (z.dt_start, 'dd.mm.yyyy') dt_start,
                         TO_CHAR (z.dt_end, 'dd.mm.yyyy') dt_end,
                         TO_CHAR (z.report_data, 'dd.mm.yyyy') report_data,
                         CASE
                            WHEN TRUNC (SYSDATE) <= TRUNC (z.report_data) THEN 1
                         END
                            srok_ok,
                         TO_CHAR (z.report_data_lu, 'dd.mm.yyyy hh24:mi:ss')
                            report_data_lu,
                         z.report_done,
                         TO_CHAR (z.report_done_lu, 'dd.mm.yyyy hh24:mi:ss')
                            report_done_lu,
                         (SELECT fio
                            FROM user_list
                           WHERE tn = z.report_data_tn)
                            report_data_fio,
                         z.report_data_text,
                         z.sup_doc,
                         u.phone,
                         u.e_mail,
                         u.skype,
                         z.rm_fio,
                         z.rm_tn,
                         z.created created_dt,
                         z.valid_no,
                         z.valid_tn,
                         fn_getname (z.valid_tn) valid_fio,
                         TO_CHAR (z.valid_lu, 'dd.mm.yyyy hh24:mi:ss') valid_lu,
                         z.valid_text,
                         fn_getname (z.tn) creator,
                         z.tn creator_tn,
                         z.recipient recipient_tn,
                         fn_getname (z.recipient) recipient,
                         za.tn acceptor_tn,
                         fn_getname (za.tn) acceptor_name,
                         za.rep_accepted accepted,
                         za.rep_failure failure,
                         za.accept_order,
                         zat.name accepted_name,
                         DECODE (za.rep_accepted,
                                 0, NULL,
                                 TO_CHAR (za.rep_lu, 'dd.mm.yyyy hh24:mi:ss'))
                            accepted_date,
                         DECODE (
                            (SELECT COUNT (*)
                               FROM bud_ru_zay_accept
                              WHERE     z_id = z.id
                                    AND rep_accepted = 2
                                    AND INN_not_ReportMA (tn) = 0),
                            0, 0,
                            1)
                            deleted,
                         (SELECT accepted
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        DECODE (
                                           NVL (
                                              (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND accepted = 2),
                                              0),
                                           0, (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE z_id = z.id),
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE z_id = z.id AND accepted = 2)))
                            z_current_accepted_id,
                         (SELECT rep_accepted
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND INN_not_ReportMA (tn) = 0
                                 AND accept_order =
                                        DECODE (
                                           NVL (
                                              (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted = 2
                                                      AND INN_not_ReportMA (tn) =
                                                             0),
                                              0),
                                           0, (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted
                                                             IS NOT NULL
                                                      AND INN_not_ReportMA (tn) =
                                                             0),
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND rep_accepted = 2
                                                   AND INN_not_ReportMA (tn) = 0)))
                            current_accepted_id,
                         (SELECT tn
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        (SELECT MIN (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE     z_id = z.id
                                                AND rep_accepted = 0
                                                AND INN_not_ReportMA (tn) = 0))
                            current_acceptor_tn,
                         (SELECT id
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        (SELECT MIN (accept_order)
                                           FROM bud_ru_zay_accept
                                          WHERE     z_id = z.id
                                                AND rep_accepted = 0
                                                AND INN_not_ReportMA (tn) = 0))
                            current_accept_id,
                         (SELECT lu
                            FROM bud_ru_zay_accept
                           WHERE     z_id = z.id
                                 AND accept_order =
                                        DECODE (
                                           NVL (
                                              (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted = 2
                                                      AND INN_not_ReportMA (tn) =
                                                             0),
                                              0),
                                           0, (SELECT MAX (accept_order)
                                                 FROM bud_ru_zay_accept
                                                WHERE     z_id = z.id
                                                      AND rep_accepted
                                                             IS NOT NULL
                                                      AND INN_not_ReportMA (tn) =
                                                             0),
                                           (SELECT MAX (accept_order)
                                              FROM bud_ru_zay_accept
                                             WHERE     z_id = z.id
                                                   AND rep_accepted = 2
                                                   AND INN_not_ReportMA (tn) = 0)))
                            current_accepted_date,
                         (SELECT COUNT (tn)
                            FROM bud_ru_zay_accept
                           WHERE z_id = z.id AND tn = :tn)
                            i_am_is_acceptor,
                         (SELECT COUNT (*)
                            FROM (SELECT DISTINCT slave tn
                                    FROM full
                                   WHERE master = :tn)
                           WHERE tn = z.tn)
                            slaves1,
                         (SELECT COUNT (*)
                            FROM (SELECT DISTINCT slave tn
                                    FROM full
                                   WHERE master = :tn)
                           WHERE tn IN (SELECT tn
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id))
                            slaves2,
                         (SELECT COUNT (*)
                            FROM assist
                           WHERE     child = :tn
                                 AND parent IN (SELECT tn
                                                  FROM bud_ru_zay_accept
                                                 WHERE z_id = z.id)
                                 AND dpt_id = (SELECT dpt_id
                                                 FROM user_list
                                                WHERE tn = z.tn))
                            slaves3,
                         (SELECT COUNT (*)
                            FROM bud_ru_zay_executors
                           WHERE tn = :tn AND z_id = z.id)
                            slaves4,
                         z.st st_id,
                         z.kat kat_id,
                         (SELECT NVL (is_do, 0)
                            FROM user_list
                           WHERE tn = :tn)
                            is_do,
                         (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn)
                            is_traid,
                         (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn)
                            is_traid_kk,
                         u.pos_id,
                         u.pos_name creator_pos_name,
                         u.region_name,
                         z.fil,
                         z.funds,
                         z.id_net,
                         z.distr_compensation,
                         z.report_zero_cost,
                         z.report_fakt_equal_plan
                    FROM bud_ru_zay z,
                         bud_ru_zay_accept za,
                         accept_types zat,
                         user_list u
                   WHERE     (SELECT NVL (tu, 0)
                                FROM bud_ru_st_ras
                               WHERE id = z.kat) = :tu
                         AND z.tn = u.tn
                         AND (   :exp_list_without_ts = 0
                              OR u.tn IN (SELECT slave
                                            FROM full
                                           WHERE master = :exp_list_without_ts))
                         AND u.dpt_id = DECODE ( :country,
                                                '0', u.dpt_id,
                                                (SELECT dpt_id
                                                   FROM departments
                                                  WHERE cnt_kod = :country))
                         AND z.id = za.z_id(+)
                         AND za.rep_accepted = zat.id(+)
                         AND za.rep_accepted IS NOT NULL
                         AND INN_not_ReportMA (za.tn) = 0) z
           WHERE     1 = z_current_accepted_id
                 AND report_data IS NOT NULL
                 AND :srok_ok =
                        DECODE ( :srok_ok, 0, 0, DECODE (srok_ok, NULL, 2, 1))
                 AND :report_done_flt =
                        DECODE (
                           :report_done_flt,
                           0, 0,
                           DECODE (
                                NVL (report_fakt_equal_plan, 0)
                              + NVL (report_done, 0),
                              0, 2,
                              1))
                 AND :report_zero_cost =
                        DECODE ( :report_zero_cost,
                                0, 0,
                                NVL (report_zero_cost, 0))
                 AND DECODE ( :status,  0, 0,  1, 1,  2, 0,  3, 0,  4, 0) =
                        DECODE ( :status,
                                0, 0,
                                1, current_accepted_id,
                                2, NVL (current_accepted_id, 0),
                                3, 0,
                                4, 0)
                 AND DECODE ( :status, 3, 1, 0) =
                        DECODE ( :status, 3, deleted, 0)
                 AND DECODE ( :status, 4, 1, 0) = NVL (valid_no, 0)
                 AND DECODE ( :who,  0, 1,  1, :tn,  2, 1) =
                        DECODE (
                           :who,
                           0, DECODE (
                                   slaves1
                                 + slaves2
                                 + slaves3
                                 + slaves4
                                 + is_do
                                 + is_traid
                                 + is_traid_kk,
                                 0, 0,
                                 1),
                           1, creator_tn,
                           2, DECODE (i_am_is_acceptor, 0, 0, 1))
                 AND DECODE ( :wait4myaccept, 0, :tn, 0) =
                        DECODE ( :wait4myaccept, 0, z.current_acceptor_tn, 0)
                 AND DECODE ( :wait4myaccept, 0, 1, 0) =
                        DECODE ( :wait4myaccept, 0, NVL (report_done, 0), 0)) z
GROUP BY current_status