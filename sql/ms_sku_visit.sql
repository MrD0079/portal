/* Formatted on 14/07/2015 16:06:44 (QP5 v5.227.12220.39724) */
  SELECT n.id_net,
         rb.ag_id,
         rb.kodtp,
         fn_getname (rh.tn) svms_name,
         rh.num num,
         rh.fio_otv fio_otv,
         cpp1.tz_oblast tz_oblast,
         cpp1.city city,
         n.net_name net_name,
         cpp1.ur_tz_name ur_tz_name,
         cpp1.tz_address tz_address,
         ra.name ag_name,
         SUM (rb.vv) vv_sum,
         COUNT (DISTINCT msb.name) sku,
         COUNT (
            DISTINCT CASE
                        WHEN (NVL (rb.vv, 0) = 0)
                        THEN
                           cpp1.kodtp || '-' || c.data || '-' || 1
                     END)
            visits_plan,
         COUNT (
            DISTINCT CASE
                        WHEN (NVL (mr.mr_fakt, 0) > 0 /*OR NVL (mr.f_fakt, 0) > 0*/)
                        THEN
                           cpp1.kodtp || '-' || c.data || '-' || 1
                     END)
            visits_fakt,
         mda.sku_price,
           COUNT (DISTINCT msb.name)
         * COUNT (
              DISTINCT CASE
                          WHEN (   NVL (mr.mr_fakt, 0) > 0
                                /*OR NVL (mr.f_fakt, 0) > 0*/)
                          THEN
                             cpp1.kodtp || '-' || c.data || '-' || 1
                       END)
            sku_visit,
           COUNT (DISTINCT msb.name)
         * COUNT (
              DISTINCT CASE
                          WHEN (   NVL (mr.mr_fakt, 0) > 0
                                /*OR NVL (mr.f_fakt, 0) > 0*/)
                          THEN
                             cpp1.kodtp || '-' || c.data || '-' || 1
                       END)
         * mda.sku_price
            sku_summa
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
         merch_report mr,
         ms_nets n,
         merch_dt_ag mda
   WHERE     (   rh.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND TRUNC (rh.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND TRUNC (c.data, 'mm') = TRUNC (TO_DATE (:ed, 'dd/mm/yyyy'), 'mm')
         AND msh.sd =
                fn_get_spec_dt (
                   msh.id_net,
                   msh.ag_id,
                   msh.kod_tp,
                   CASE
                      WHEN :period = 1
                      THEN
                         TO_DATE (:ed, 'dd.mm.yyyy')
                      WHEN :period = 2
                      THEN
                         (SELECT MAX (c2.data)
                            FROM calendar c1, calendar c2
                           WHERE     c1.data = TO_DATE (:ed, 'dd.mm.yyyy')
                                 AND c1.y = c2.y
                                 AND c1.wy = c2.wy)
                      WHEN :period = 3
                      THEN
                         LAST_DAY (TO_DATE (:ed, 'dd.mm.yyyy'))
                   END)
         AND (rb.DAY_ENABLED_MR = 1 /*OR rb.DAY_ENABLED_F = 1*/)
         /*AND (NVL (mr.mr_fakt, 0) > 0 OR NVL (mr.f_fakt, 0) > 0)*/
         AND rb.id = mr.rb_id(+)
         AND c.dm = rb.day_num
         AND rh.id = rha.head_id
         AND rh.id = rb.head_id
         AND rh.id = rt.head_id
         AND rha.ag_id = rb.ag_id
         AND rb.kodtp = rt.kodtp
         AND rha.ag_id = msh.ag_id
         AND rb.kodtp = msh.kod_tp
         AND rb.ag_id = msh.ag_id
         AND rt.kodtp = msh.kod_tp
         AND msh.id = msb.head_id
         AND msh.id_net = cpp1.id_net
         AND rha.ag_id = ra.id
         AND rb.kodtp = cpp1.kodtp
         AND rh.tn = s.tn
         AND cpp1.tz_oblast = s.oblast
         AND (   (c.data IN (TO_DATE (:ed, 'dd.mm.yyyy')) AND :period = 1)
              OR (    c.data IN
                         (SELECT c2.data
                            FROM calendar c1, calendar c2
                           WHERE     c1.data = TO_DATE (:ed, 'dd.mm.yyyy')
                                 AND c1.y = c2.y
                                 AND c1.wy = c2.wy)
                  AND :period = 2)
              OR (    TRUNC (c.data, 'mm') = TO_DATE (:ed, 'dd.mm.yyyy')
                  AND :period = 3))
         AND DECODE (:svms_list, 0, 0, rh.tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND DECODE (:agent, 0, 0, rb.ag_id) = DECODE (:agent, 0, 0, :agent)
         AND DECODE (:nets, 0, 0, n.id_net) = DECODE (:nets, 0, 0, :nets)
         AND DECODE (:oblast, '0', '0', cpp1.tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', cpp1.city) =
                DECODE (:city, '0', '0', :city)
         AND n.id_net = cpp1.id_net
         AND rb.ag_id = mda.ag_id(+)
         AND TRUNC (TO_DATE (:ed, 'dd.mm.yyyy'), 'mm') = mda.dt(+)
GROUP BY n.id_net,
         rb.ag_id,
         rb.kodtp,
         rh.tn,
         rh.num,
         rh.fio_otv,
         cpp1.tz_oblast,
         cpp1.city,
         n.net_name,
         cpp1.ur_tz_name,
         cpp1.tz_address,
         ra.name,
         mda.sku_price
ORDER BY svms_name,
         num,
         fio_otv,
         ag_name