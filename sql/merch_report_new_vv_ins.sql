/* Formatted on 09.07.2014 11:33:19 (QP5 v5.227.12220.39724) */
BEGIN
   FOR a IN (SELECT id FROM routes_agents /*SELECT DISTINCT rb_ag_id id
                                            FROM ms_rep_routes
                                           WHERE     rh_data = TRUNC (TO_DATE (:dt, 'dd.mm.yyyy'), 'mm')
                                                 AND rb_kodtp = :kod_tp*/
                                         )
   LOOP
      /* pr_merch_report_vv_ins1 (:head_id,
                               :kod_tp,
                               a.id,
                               :dt);*/
      NULL;
   END LOOP;



   pr_merch_report_vv_ins1 (:head_id,
                            :kod_tp,
                            :ag_id,
                            :dt);
END;