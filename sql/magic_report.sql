/* Formatted on 11.01.2013 13:23:23 (QP5 v5.163.1008.3004) */
  SELECT s.tab_number,
         s.ts,
         s.eta,
         s.kod_tp,
         s.tp_name,
         s.address,
         v.selected,
         v.ok_traid,
         s.v31122011 * 0.7 december,
         s.v31012012 january,
         s.avg6,
         v.contact_lpr,
         v.jan_plan
    FROM sh_o_2011 s, magic_tp_select v, spdtree st
   WHERE     s.tab_number = st.tab_num
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_without_ts, 0, :tn, :exp_list_without_ts))
         AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = DECODE (:exp_list_only_ts, 0, :tn, :exp_list_only_ts))
         AND s.kod_tp = v.kod_tp(+)
         AND v.selected = 1
         AND st.dpt_id = :dpt_id
ORDER BY s.ts,
         s.eta,
         s.tp_name,
         s.address