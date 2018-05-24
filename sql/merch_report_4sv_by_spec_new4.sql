/* Formatted on 02.02.2014 22:40:11 (QP5 v5.227.12220.39724) */
SELECT SUM (msb.weight) msb_weight,
       SUM (msr.r_remain) msr_remain,
       SUM (msr.r_oos) msr_oos,
       SUM (msr.r_gos) msr_gos,
       SUM (msr.r_fcount) msr_fcount,
       SUM (msr.r_price) msr_price,
       COUNT (*) c,
	   
	   
	   decode(count(*),0,0,SUM (msr.r_oos)/ COUNT (*) * 100) perc_oos
	   
	   
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
         AND (ms_rep_routes1.rh_tn IN (SELECT slave
                               FROM full
                              WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
