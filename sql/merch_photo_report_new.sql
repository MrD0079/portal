/* Formatted on 19.03.2014 8:59:39 (QP5 v5.227.12220.39724) */
  SELECT cpp1_tz_oblast tz_oblast,
         n_net_name net_name,
         cpp1_ur_tz_name ur_tz_name,
         cpp1_tz_address tz_address,
         rb_kodtp kodtp,
         ra_name ag_name,
         rb_ag_id ag_id,
         TO_CHAR (c.data, 'dd.mm.yyyy') dt,
         /*rh_num num,
         rh_id head_id, */
         f.fn
    FROM merch_report mr,
         ms_rep_routes1 r,
         (SELECT DISTINCT data, dw FROM calendar) c,
         merch_spec_report_files f
   WHERE     c.data BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                        AND TO_DATE (:ed, 'dd/mm/yyyy')
         AND mr.dt = c.data
         AND r.rb_id = mr.rb_id
         AND r.rb_ag_id = f.ag_id
         AND r.rb_kodtp = f.kod_tp
         AND c.data = f.dt
         AND r.rh_data BETWEEN TRUNC (TO_DATE (:sd, 'dd/mm/yyyy'), 'mm')
                           AND TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND DECODE (:agent, 0, 0, r.rb_ag_id) = DECODE (:agent, 0, 0, :agent)
         AND DECODE (:nets, 0, 0, r.n_id_net) = DECODE (:nets, 0, 0, :nets)
         AND DECODE (:oblast, '0', '0', r.cpp1_tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', r.cpp1_city) =
                DECODE (:city, '0', '0', :city)
         AND (   r.rh_tn IN (SELECT emp_tn
                               FROM who_full
                              WHERE exp_tn = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1)
GROUP BY cpp1_tz_oblast,
         n_net_name,
         cpp1_ur_tz_name,
         cpp1_tz_address,
         rb_kodtp,
         ra_name,
         rb_ag_id,
         /*rh_num,
         rh_id,*/
         c.data,
         f.fn
ORDER BY cpp1_tz_oblast,
         n_net_name,
         cpp1_ur_tz_name,
         cpp1_tz_address,
         rb_kodtp,
         ra_name,
         rb_ag_id,
         /*rh_num,
         rh_id,*/
         c.data,
         f.fn