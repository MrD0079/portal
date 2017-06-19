/* Formatted on 05/04/2016 19:37:01 (QP5 v5.252.13127.32867) */
  SELECT u.fio ts,
         r.h_eta,
         r.eta,
         r.tp_name,
         r.address tp_address,
         r.tp_kod,
         t.delay,
         t.discount,
         t.bonus,
         t.justification,
         t.fixed,
         t.margin,
		 to_char(t.fixed_lu,'dd.mm.yyyy hh24:mi:ss') fixed_lu,
		 to_char(t.justification_lu,'dd.mm.yyyy hh24:mi:ss') justification_lu
    FROM (SELECT DISTINCT h_eta,
                          eta,
                          tp_name,
                          address,
                          tp_kod,
                          olstatus,
                          country,
                          tab_number
            FROM routes) r,
         user_list u,
         sc_tp t,
         departments d
   WHERE     r.tab_number = u.tab_num
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
         /*AND u.datauvol IS NULL*/
         AND u.dpt_id = :dpt_id
     and u.is_spd=1
    AND :dpt_id = t.dpt_id(+)
         AND r.tp_kod = t.tp_kod(+)
         AND (   :exp_list_without_ts = 0
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
              OR u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_only_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = DECODE ( :tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE ( :routes_eta_list, '', r.h_eta, :routes_eta_list) =
                r.h_eta
         AND DECODE ( :sc,  0, 0,  1, 1,  2, 1) =
                DECODE (
                   :sc,
                   0, 0,
                   1, CASE
                         WHEN    discount > 0
                              OR bonus > 0
                              OR fixed > 0
                              OR margin > 0
                         THEN
                            1
                         ELSE
                            0
                      END,
                   2, CASE
                         WHEN     (   discount > 0
                                   OR bonus > 0
                                   OR fixed > 0
                                   OR margin > 0)
                              AND (SELECT COUNT (*)
                                     FROM sc_files
                                    WHERE tp_kod = t.tp_kod) = 0
                         THEN
                            1
                         ELSE
                            0
                      END)
         AND DECODE ( :sc_tp,  0, 0,  1, 0,  2, 1) =
                DECODE ( :sc_tp,  0, 0,  1, r.olstatus,  2, r.olstatus)
         AND DECODE ( :region_name, '0', '0', :region_name) =
                DECODE ( :region_name, '0', '0', region_name)
         AND DECODE ( :department_name, '0', '0', :department_name) =
                DECODE ( :department_name, '0', '0', department_name)
ORDER BY ts,
         eta,
         tp_name,
         tp_address