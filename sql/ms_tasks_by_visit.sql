/* Formatted on 13/05/2016 11:06:00 (QP5 v5.252.13127.32867) */
  SELECT ag_id,
         tz_oblast,
         city,
         ur_tz_name,
         tz_address,
         kodtp,
         net_name,
         ag_name,
         svms_name,
         tsk_good,
         tsk_bad,
         tsk_good + tsk_bad tsk_total,
         DECODE (tsk_good + tsk_bad,
                 0, 0,
                 tsk_good / (tsk_good + tsk_bad) * 100)
            tsk_good_perc
    FROM (  SELECT ag_id,
                   tz_oblast,
                   city,
                   ur_tz_name,
                   tz_address,
                   kodtp,
                   net_name,
                   ag_name,
                   svms_name,
                     SUM (
                        CASE
                           WHEN mc_cnt > 0 AND mc_response_ok = 1 THEN 1
                           ELSE 0
                        END)
                   + SUM (
                        CASE
                           WHEN msrfc_cnt > 0 AND msrfc_response_ok = 1 THEN 1
                           ELSE 0
                        END)
                      tsk_good,
                     SUM (
                        CASE
                           WHEN mc_cnt > 0 AND mc_response_ok = 0 THEN 1
                           ELSE 0
                        END)
                   + SUM (
                        CASE
                           WHEN msrfc_cnt > 0 AND msrfc_response_ok = 0 THEN 1
                           ELSE 0
                        END)
                      tsk_bad
              FROM (SELECT DISTINCT
                           TO_CHAR (x.data, 'dd.mm.yyyy') dt1,
                           x.data,
                           x.svms_name,
                           x.ag_id,
                           x.tz_oblast,
                           x.city,
                           x.ur_tz_name,
                           x.tz_address,
                           x.kodtp,
                           x.net_name,
                           x.ag_name,
                           fn_get_mc_response_ok (x.data, x.ag_id, x.kodtp)
                              mc_response_ok,
                           FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) mc_cnt,
                           fn_get_msrfc_response_ok (x.data, x.ag_id, x.kodtp)
                              msrfc_response_ok,
                           FN_GET_msrfc_cnt1 (x.data, x.ag_id, x.kodtp) msrfc_cnt
                      FROM (SELECT DISTINCT n_id_net,
                                            rb_ag_id ag_id,
                                            rb_kodtp kodtp,
                                            rb_data data,
                                            fn_getname (rh_tn) svms_name,
                                            rh_num num,
                                            cpp1_tz_oblast tz_oblast,
                                            cpp1_city city,
                                            n_net_name net_name,
                                            cpp1_ur_tz_name ur_tz_name,
                                            cpp1_tz_address tz_address,
                                            ra_name ag_name
                              FROM ms_rep_routes1 r
                             WHERE     (   rh_tn IN (SELECT slave
                                                       FROM full
                                                      WHERE master = :tn)
                                        OR (SELECT is_ma
                                              FROM user_list
                                             WHERE tn = :tn) = 1
                                        OR (SELECT is_admin
                                              FROM user_list
                                             WHERE tn = :tn) = 1)
                                   AND (   (    rb_data IN (TO_DATE (
                                                               :day_list,
                                                               'dd.mm.yyyy'))
                                            AND :period = 1
                                            AND rh_data =
                                                   TRUNC (
                                                      TO_DATE ( :day_list,
                                                               'dd.mm.yyyy'),
                                                      'mm'))
                                        OR (    rb_data IN (SELECT c2.data
                                                              FROM calendar c1,
                                                                   calendar c2
                                                             WHERE     c1.data =
                                                                          TO_DATE (
                                                                             :week_list,
                                                                             'dd.mm.yyyy')
                                                                   AND c1.y =
                                                                          c2.y
                                                                   AND c1.wy =
                                                                          c2.wy)
                                            AND :period = 2
                                            AND rh_data IN (SELECT DISTINCT
                                                                   TRUNC (
                                                                      c2.data,
                                                                      'mm')
                                                              FROM calendar c1,
                                                                   calendar c2
                                                             WHERE     c1.data =
                                                                          TO_DATE (
                                                                             :week_list,
                                                                             'dd.mm.yyyy')
                                                                   AND c1.y =
                                                                          c2.y
                                                                   AND c1.wy =
                                                                          c2.wy))
                                        OR (    TRUNC (rb_data, 'mm') =
                                                   TO_DATE ( :month_list, 'dd.mm.yyyy')
                                            AND :period = 3
                                            AND rh_data =
                                                   TO_DATE ( :month_list, 'dd.mm.yyyy')))
                                   AND DECODE ( :svms_list, 0, 0, rh_tn) =
                                          DECODE ( :svms_list, 0, 0, :svms_list)
                                   AND DECODE ( :agent, 0, 0, rb_ag_id) =
                                          DECODE ( :agent, 0, 0, :agent)
                                   AND DECODE ( :nets, 0, 0, n_id_net) =
                                          DECODE ( :nets, 0, 0, :nets)
                                   AND DECODE ( :oblast,
                                               '0', '0',
                                               cpp1_tz_oblast) =
                                          DECODE ( :oblast, '0', '0', :oblast)
                                   AND DECODE ( :city, '0', '0', cpp1_city) =
                                          DECODE ( :city, '0', '0', :city)) x
                     WHERE    FN_GET_msrfc_cnt1 (x.data, x.ag_id, x.kodtp) > 0
                           OR FN_GET_mc_cnt (x.data, x.ag_id, x.kodtp) > 0)
          GROUP BY ag_id,
                   tz_oblast,
                   city,
                   ur_tz_name,
                   tz_address,
                   kodtp,
                   net_name,
                   ag_name,
                   svms_name)
ORDER BY svms_name,
         tz_oblast,
         city,
         net_name,
         ur_tz_name,
         tz_address,
         ag_name