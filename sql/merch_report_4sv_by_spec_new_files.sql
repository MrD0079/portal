/* Formatted on 09.02.2014 21:06:26 (QP5 v5.227.12220.39724) */
  SELECT distinct TO_CHAR (ms_rep_routes1.rb_data, 'dd.mm.yyyy') dt,
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
f.chat_closed,
         cpp1_tz_address tz_address,
            TO_CHAR (ms_rep_routes1.rb_data, 'dd.mm.yyyy')
         || '/'
         || f.ag_id
         || '/'
         || f.kod_tp
            PATH,
         (SELECT COUNT (*)
            FROM merch_spec_report_files_chat
           WHERE msr_file_id = f.id)
            c,
         f.last_is_spd
    FROM (SELECT r_id,
                 r_spec_id,
                 r_dt,
                 r_remain,
                 r_oos,
                 r_gos,
                 r_fcount,
                 r_price,
                 r_text
            FROM ms_rep_hbr,
                 (  SELECT h_id, r_dt dt
                      FROM ms_rep_hbr
                     WHERE r_dt = TO_DATE (:ed, 'dd.mm.yyyy')
                  GROUP BY h_id, r_dt) h1
           WHERE ms_rep_hbr.b_head_id = h1.h_id AND ms_rep_hbr.r_dt = h1.dt) msr,
         MS_REP_HBR_DT msh,
         merch_spec_body msb,
         merch_report mr,
         ms_rep_routes1 /*,
          (SELECT DISTINCT data, dm FROM calendar) c*/
                       ,
         merch_spec_report_files f
   WHERE     msh.kod_tp = ms_rep_routes1.rb_kodtp
         AND msh.ag_id = ms_rep_routes1.rb_ag_id
         AND msh.id_net = ms_rep_routes1.n_id_net
         AND msb.head_id = msh.id
         AND msr.r_spec_id = msb.id
         AND ms_rep_routes1.rb_id = mr.rb_id
         AND mr.dt = TO_DATE (:ed, 'dd.mm.yyyy')
         AND msh.data = TO_DATE (:ed, 'dd.mm.yyyy')
         /*AND mr.dt = c.data*/
         AND mr.dt = ms_rep_routes1.rb_data
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
         AND f.dt = ms_rep_routes1.rb_data
         AND f.ag_id = ms_rep_routes1.rb_ag_id
         AND F.KOD_TP = ms_rep_routes1.rb_kodtp
         AND (ms_rep_routes1.rh_tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn UNION
                        SELECT chief
                          FROM spr_users_ms
                         WHERE     login = :login
                               AND (SELECT is_smr
                                      FROM user_list
                                     WHERE login = :login) = 1)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY PATH