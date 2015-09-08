/* Formatted on 22/02/2014 18:39:28 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         TO_CHAR (ms_rep_routes1.rb_data, 'dd.mm.yyyy') dt,
         TO_CHAR (ms_rep_routes1.rb_data, 'yyyymmdd') dt1,
         ms_rep_routes1.rb_data,
         ms_rep_routes1.rh_num num,
         ms_rep_routes1.rh_fio_otv fio_otv,
         ms_rep_routes1.rh_id head_id,
         fn_getname ( ms_rep_routes1.rh_tn) svms_name,
         ms_rep_routes1.cpp1_tz_oblast tz_oblast,
         ms_rep_routes1.cpp1_city city,
         ms_rep_routes1.n_net_name net_name,
         ms_rep_routes1.n_id_net id_net,
         ms_rep_routes1.cpp1_ur_tz_name ur_tz_name,
         ms_rep_routes1.cpp1_tz_address tz_address,
         ms_rep_routes1.rb_kodtp kodtp,
         ms_rep_routes1.ra_name ag_name,
         ms_rep_routes1.rb_ag_id ag_id,
         f.id msr_file_id,
         f.fn,
         NVL (f.chat_closed, 0) chat_closed,
         FN_GET_msrfc_cnt (f.id) c,
         FN_GET_msrfc_last (f.id) last_is_spd,
         FN_GET_mc_cnt (ms_rep_routes1.rb_data,
                        ms_rep_routes1.rb_ag_id,
                        ms_rep_routes1.rb_kodtp)
            mc_c,
         FN_GET_mc_closed (ms_rep_routes1.rb_data,
                           ms_rep_routes1.rb_ag_id,
                           ms_rep_routes1.rb_kodtp)
            mc_closed,
         FN_GET_mc_last (ms_rep_routes1.rb_data,
                         ms_rep_routes1.rb_ag_id,
                         ms_rep_routes1.rb_kodtp)
            mc_last_is_spd
    FROM ms_rep_routes1, merch_spec_report_files f, merch_chat c
   WHERE     ms_rep_routes1.rb_data BETWEEN TO_DATE (:sd, 'dd.mm.yyyy')
                                        AND TO_DATE (:ed, 'dd.mm.yyyy')
         AND DECODE (:svms_list, 0, 0, ms_rep_routes1.rh_tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND DECODE (:agent, 0, 0, ms_rep_routes1.rb_ag_id) =
                DECODE (:agent, 0, 0, :agent)
         AND DECODE (:nets, 0, 0, ms_rep_routes1.n_id_net) =
                DECODE (:nets, 0, 0, :nets)
         AND DECODE (:oblast, '0', '0', ms_rep_routes1.cpp1_tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', ms_rep_routes1.cpp1_city) =
                DECODE (:city, '0', '0', :city)
         AND DECODE (:select_route_numb, 0, 0, ms_rep_routes1.rh_id) =
                DECODE (:select_route_numb, 0, 0, :select_route_numb)
         AND DECODE (:select_route_fio_otv, 0, 0, ms_rep_routes1.rh_id) =
                DECODE (:select_route_fio_otv, 0, 0, :select_route_fio_otv)
         AND ms_rep_routes1.rb_data = f.dt(+)
         AND ms_rep_routes1.rb_ag_id = f.ag_id(+)
         AND ms_rep_routes1.rb_kodtp = F.KOD_TP(+)
         AND ms_rep_routes1.rb_data = c.dt(+)
         AND ms_rep_routes1.rb_ag_id = c.ag_id(+)
         AND ms_rep_routes1.rb_kodtp = c.KOD_TP(+)
         AND (   FN_GET_msrfc_cnt (f.id) > 0
              OR FN_GET_mc_cnt (ms_rep_routes1.rb_data,
                                ms_rep_routes1.rb_ag_id,
                                ms_rep_routes1.rb_kodtp) > 0)
         AND CASE
                WHEN :flt_chat = 0
                THEN
                   1
                WHEN     :flt_chat = 1
                     AND (   NVL (f.chat_closed, 0) = 1
                          OR FN_GET_mc_closed (ms_rep_routes1.rb_data,
                                               ms_rep_routes1.rb_ag_id,
                                               ms_rep_routes1.rb_kodtp) = 1)
                THEN
                   1
                WHEN     :flt_chat = 2
                     AND (   (    FN_GET_msrfc_last (f.id) = 1
                              AND NVL (f.chat_closed, 0) = 0)
                          OR (    FN_GET_mc_last (ms_rep_routes1.rb_data,
                                                  ms_rep_routes1.rb_ag_id,
                                                  ms_rep_routes1.rb_kodtp) = 1
                              AND FN_GET_mc_closed (ms_rep_routes1.rb_data,
                                                    ms_rep_routes1.rb_ag_id,
                                                    ms_rep_routes1.rb_kodtp) =
                                     0))
                THEN
                   1
                WHEN     :flt_chat = 3
                     AND (   (    FN_GET_msrfc_last (f.id) = -1
                              AND NVL (f.chat_closed, 0) = 0)
                          OR (    FN_GET_mc_last (ms_rep_routes1.rb_data,
                                                  ms_rep_routes1.rb_ag_id,
                                                  ms_rep_routes1.rb_kodtp) = -1
                              AND FN_GET_mc_closed (ms_rep_routes1.rb_data,
                                                    ms_rep_routes1.rb_ag_id,
                                                    ms_rep_routes1.rb_kodtp) =
                                     0))
                THEN
                   1
             END = 1
ORDER BY ms_rep_routes1.rb_data,
         tz_oblast,
         city,
         ur_tz_name,
         tz_address,
         f.fn