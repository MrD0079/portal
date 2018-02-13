/* Formatted on 20.01.2018 11:31:20 (QP5 v5.252.13127.32867) */
SELECT SUM (msb_weight) msb_weight,
       SUM (msr_remain) msr_remain,
       SUM (msr_oos) msr_oos,
       SUM (msr_fcount) msr_fcount,
       SUM (msr_price) msr_price,
       COUNT (*) c
  FROM (  SELECT TO_CHAR (NVL (msr.r_DT, TO_DATE ( :ed, 'dd/mm/yyyy')),
                          'dd.mm.yyyy')
                    dt,
                 NVL (msr.r_dt, TO_DATE ( :ed, 'dd/mm/yyyy')) dt1,
                 wm_concat (DISTINCT ms_rep_routes1.rh_num) num,
                 wm_concat (DISTINCT ms_rep_routes1.rh_id) head_id,
                 wm_concat (DISTINCT fn_getname (ms_rep_routes1.rh_tn)) svms_name,
                 ms_rep_routes1.cpp1_tz_oblast tz_oblast,
                 ms_rep_routes1.cpp1_city city,
                 ms_rep_routes1.n_net_name net_name,
                 ms_rep_routes1.n_id_net id_net,
                 ms_rep_routes1.cpp1_ur_tz_name ur_tz_name,
                 ms_rep_routes1.cpp1_tz_address tz_address,
                 ms_rep_routes1.rb_kodtp kodtp,
                 ms_rep_routes1.ra_name ag_name,
                 ms_rep_routes1.rb_ag_id ag_id,
                 msb.id msb_id,
                 msb.sort msb_sort,
                 msb.art msb_art,
                 msb.name msb_name,
                 msb.brand msb_brand,
                 msb.izm msb_izm,
                 msb.weight msb_weight,
                 msb.kod msb_kod,
                 msr.r_id msr_id,
                 msr.r_remain msr_remain,
                 msr.r_oos msr_oos,
                 msr.r_fcount msr_fcount,
                 msr.r_price msr_price,
                 msr.r_text msr_text
            FROM ms_rep_hbr_max_dt msr,
                 MS_REP_HBR_DT msh,
                 merch_spec_body msb,
                 merch_report mr,
                 ms_rep_routes1
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
        GROUP BY msr.r_dt,
                 ms_rep_routes1.cpp1_tz_oblast,
                 ms_rep_routes1.cpp1_city,
                 ms_rep_routes1.n_net_name,
                 ms_rep_routes1.n_id_net,
                 ms_rep_routes1.cpp1_ur_tz_name,
                 ms_rep_routes1.cpp1_tz_address,
                 ms_rep_routes1.rb_kodtp,
                 ms_rep_routes1.ra_name,
                 ms_rep_routes1.rb_ag_id,
                 msb.id,
                 msb.sort,
                 msb.art,
                 msb.name,
                 msb.brand,
                 msb.izm,
                 msb.weight,
                 msb.kod,
                 msr.r_id,
                 msr.r_remain,
                 msr.r_oos,
                 msr.r_fcount,
                 msr.r_price,
                 msr.r_text)