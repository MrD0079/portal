/* Formatted on 02/06/2015 10:57:17 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         TO_CHAR (NVL (msr.r_DT, TO_DATE (:ed, 'dd/mm/yyyy')), 'dd.mm.yyyy') dt,
         ms_rep_routes1.cpp1_tz_oblast tz_oblast,
         ms_rep_routes1.cpp1_city city,
         ms_rep_routes1.n_net_name net_name,
         ms_rep_routes1.cpp1_ur_tz_name ur_tz_name,
         ms_rep_routes1.cpp1_tz_address tz_address,
         ms_rep_routes1.rb_kodtp kodtp,
         f.fn,
         f.id msr_file_id,
            TO_CHAR (NVL (msr.r_DT, TO_DATE (:ed, 'dd/mm/yyyy')), 'dd.mm.yyyy')
         || '/'
         || f.ag_id
         || '/'
         || f.kod_tp
            PATH,
         (SELECT COUNT (*)
            FROM merch_spec_report_files_chat
           WHERE msr_file_id = f.id)
            c
    FROM /*( SELECT r_id,
         r_spec_id,
         r_dt,
         r_remain,
         r_oos,
         r_fcount,
         r_price,
         r_text
    FROM ms_rep_hbr,
         (  SELECT h_id, MAX (r_dt) dt
              FROM ms_rep_hbr
             WHERE TO_DATE ( :ed, 'dd/mm/yyyy') - msv_dt <= 3
          GROUP BY h_id) h1
   WHERE ms_rep_hbr.b_head_id = h1.h_id AND ms_rep_hbr.r_dt = h1.dt)*/ms_rep_hbr_max_dt msr,
         MS_REP_HBR_DT msh,
         merch_spec_body msb,
         merch_report mr,
         ms_rep_routes1,
         /*merch_report_ok mro,*/
         merch_spec_report_files f
   WHERE     msh.kod_tp = ms_rep_routes1.rb_kodtp
         AND msh.ag_id = ms_rep_routes1.rb_ag_id
         AND msh.id_net = ms_rep_routes1.n_id_net
         AND msb.head_id = msh.id
         AND msr.r_spec_id = msb.id
         AND ms_rep_routes1.rb_id = mr.rb_id
         AND msh.data = TO_DATE (:ed, 'dd.mm.yyyy')
                 AND msr.dt = TO_DATE (:ed, 'dd.mm.yyyy')
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
         /*AND mro.dt = msr.r_dt
         AND mro.head_id = ms_rep_routes1.rh_id
         AND mro.svms_ok = 1*/
         AND f.dt = NVL (msr.r_DT, TO_DATE (:ed, 'dd/mm/yyyy'))
         AND f.ag_id = ms_rep_routes1.rb_ag_id
         AND F.KOD_TP = ms_rep_routes1.rb_kodtp
ORDER BY PATH, fn