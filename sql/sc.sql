/* Formatted on 07/04/2015 11:34:41 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.fio ts,
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
                  t.margin
    FROM routes r,
         user_list u,
         sc_tp t,
         departments d
   WHERE     r.tab_number = u.tab_num
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
         /*AND u.datauvol IS NULL*/
         AND u.dpt_id = :dpt_id
         AND :dpt_id = t.dpt_id(+)
         AND r.tp_kod = t.tp_kod(+)
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_only_ts,
                                   0, master,
                                   :exp_list_only_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:routes_eta_list, '', r.h_eta, :routes_eta_list) = r.h_eta
         AND DECODE (:sc,  0, 0,  1, 1,  2, 1) =
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
         AND DECODE (:sc_tp,  0, 0,  1, 0,  2, 1) =
                DECODE (:sc_tp,  0, 0,  1, r.olstatus,  2, r.olstatus)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', department_name)
ORDER BY ts,
         eta,
         tp_name,
         tp_address