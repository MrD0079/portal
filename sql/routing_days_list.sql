/* Formatted on 09/04/2015 17:38:13 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT SUBSTR (day_pos, 1, 1) col
    FROM (SELECT DISTINCT r.day_pos
            FROM routes r, full w, user_list u
           WHERE     r.olstatus = 1
                 AND r.dpt_id = u.dpt_id
                 AND r.tab_number = u.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND (   w.master = DECODE (:tn,
                                            -1, (SELECT MAX (tn)
                                                   FROM user_list
                                                  WHERE is_admin = 1),
                                            :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn)) = 1
                      OR (SELECT NVL (is_super, 0)
                            FROM user_list
                           WHERE tn = DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn)) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = DECODE (:tn,
                                              -1, (SELECT MAX (tn)
                                                     FROM user_list
                                                    WHERE is_admin = 1),
                                              :tn)) = 1)
                 AND u.datauvol IS NULL
                 AND DECODE (DECODE (:tn, -1, :routes_eta_list, ''),
                             '', r.h_eta,
                             DECODE (:tn, -1, :routes_eta_list, '')) = r.h_eta) z
ORDER BY col