/* Formatted on 20.01.2018 11:31:58 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT
         TO_CHAR (NVL (msr.r_DT, TO_DATE ( :ed, 'dd/mm/yyyy')), 'dd.mm.yyyy') dt,
         ms_rep_routes1.cpp1_tz_oblast tz_oblast,
         ms_rep_routes1.cpp1_city city,
         ms_rep_routes1.n_net_name net_name,
         ms_rep_routes1.cpp1_ur_tz_name ur_tz_name,
         ms_rep_routes1.cpp1_tz_address tz_address,
         ms_rep_routes1.rb_kodtp kodtp,
         f.fn,
         f.id msr_file_id,
            TO_CHAR (NVL (msr.r_DT, TO_DATE ( :ed, 'dd/mm/yyyy')), 'dd.mm.yyyy')
         || '/'
         || f.ag_id
         || '/'
         || f.kod_tp
            PATH,
         (SELECT COUNT (*)
            FROM merch_spec_report_files_chat
           WHERE msr_file_id = f.id)
            c
    FROM ms_rep_hbr_max_dt msr,
         MS_REP_HBR_DT msh,
         merch_spec_body msb,
         merch_report mr,
         ms_rep_routes1,
         merch_spec_report_files f
   WHERE     msh.kod_tp = ms_rep_routes1.rb_kodtp
         AND msh.ag_id = ms_rep_routes1.rb_ag_id
         AND msh.id_net = ms_rep_routes1.n_id_net
         AND msb.head_id = msh.id
         AND msr.r_spec_id = msb.id
         AND ms_rep_routes1.rb_id = mr.rb_id
         AND msh.data = TO_DATE ( :ed, 'dd.mm.yyyy')
         AND msr.dt = TO_DATE ( :ed, 'dd.mm.yyyy')
         AND DECODE ( :svms_list, 0, 0, ms_rep_routes1.rh_tn) =
                DECODE ( :svms_list, 0, 0, :svms_list)
         AND DECODE ( :agent, 0, 0, ms_rep_routes1.rb_ag_id) =
                DECODE ( :agent, 0, 0, :agent)
         AND DECODE ( :nets, 0, 0, ms_rep_routes1.n_id_net) =
                DECODE ( :nets, 0, 0, :nets)
         AND DECODE ( :oblast, '0', '0', ms_rep_routes1.cpp1_tz_oblast) =
                DECODE ( :oblast, '0', '0', :oblast)
         AND DECODE ( :city, '0', '0', ms_rep_routes1.cpp1_city) =
                DECODE ( :city, '0', '0', :city)
         AND f.dt = NVL (msr.r_DT, TO_DATE ( :ed, 'dd/mm/yyyy'))
         AND f.ag_id = ms_rep_routes1.rb_ag_id
         AND F.KOD_TP = ms_rep_routes1.rb_kodtp
ORDER BY PATH, fn