/* Formatted on 12/11/2014 13:33:37 (QP5 v5.227.12220.39724) */
  SELECT rh.data,
         rh.num,
         rh.tn,
         rh.id head_id,
         fn_getname ( rh.tn) svms_name,
         rh.fio_otv,
         ra.id ag_id,
         ra.name ag_name,
         COUNT (DISTINCT msb.name) sku,
         COUNT (DISTINCT cpp1.kodtp || c.data) visits,
         COUNT (DISTINCT msb.name || cpp1.kodtp || c.data) total
    FROM merch_spec_head msh,
         merch_spec_body msb,
         routes_body1 rb,
         routes_head rh,
         routes_head_agents rha,
         routes_agents ra,
         routes_tp rt,
         cpp cpp1,
         svms_oblast s,
         calendar c,
         merch_report mr
   WHERE     TRUNC (rh.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND TRUNC (c.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND msh.sd = fn_get_spec_dt (msh.id_net,
                                      msh.ag_id,
                                      msh.kod_tp,
                                      c.data)
         AND (rb.DAY_ENABLED_MR = 1 /*OR rb.DAY_ENABLED_F = 1*/)
         AND (NVL (mr.mr_fakt, 0) > 0 /*OR NVL (mr.f_fakt, 0) > 0*/)
         AND rb.id = mr.rb_id
         AND c.dm = rb.day_num
         AND rh.id = rha.head_id
         AND rh.id = rb.head_id
         AND rh.id = rt.head_id
         AND rha.ag_id = rb.ag_id
         AND rha.ag_id = msh.ag_id
         AND rb.kodtp = msh.kod_tp
         AND rb.kodtp = rt.kodtp
         AND rb.ag_id = msh.ag_id
         AND rt.kodtp = msh.kod_tp
         AND msh.id = msb.head_id
         AND rha.ag_id = ra.id
         AND rb.kodtp = cpp1.kodtp
         AND msh.id_net = cpp1.id_net
         AND rh.tn = s.tn
         AND cpp1.tz_oblast = s.oblast
         AND DECODE (:svms_list, 0, 0, rh.tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND DECODE (:select_route_numb, 0, 0, rh.id) =
                DECODE (:select_route_numb, 0, 0, :select_route_numb)
GROUP BY rh.data,
         rh.num,
         rh.tn,
         rh.id,
         rh.fio_otv,
         ra.id,
         ra.name
ORDER BY svms_name,
         num,
         fio_otv,
         ag_name