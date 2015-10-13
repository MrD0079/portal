/* Formatted on 08/10/2015 17:42:33 (QP5 v5.252.13127.32867) */
SELECT DECODE (ROUND (ROWNUM / 2) * 2, ROWNUM, 1, 0) color,
       z.tn,
       z.fio ts,
       z.h_eta,
       z.eta,
       z.day_pos day,
       z.day_pos dwt,
       z.h_day_pos h_dwt
  FROM (  SELECT DISTINCT u.tn,
                          u.fio,
                          r.h_eta,
                          r.eta,
                          r.day_pos,
                          r.h_day_pos
            FROM routes r, full w, user_list u
           WHERE     r.olstatus = 1
                 AND r.dpt_id = u.dpt_id
                 AND r.tab_number = u.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND (   w.master = DECODE ( :tn,
                                            -1, (SELECT MAX (tn)
                                                   FROM user_list
                                                  WHERE is_admin = 1),
                                            :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_super, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND u.datauvol IS NULL
                 AND u.tn IN (SELECT slave
                                FROM full
                               WHERE master =
                                        DECODE (
                                           :exp_list_without_ts,
                                           0, DECODE (
                                                 :tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                           :exp_list_without_ts))
                 AND u.tn IN (SELECT slave
                                FROM full
                               WHERE master =
                                        DECODE (
                                           :exp_list_only_ts,
                                           0, DECODE (
                                                 :tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                           :exp_list_only_ts))
                 AND DECODE ( :routes_eta_list, '', r.h_eta, :routes_eta_list) =
                        r.h_eta
                 AND md5hash (day_pos) IN ( :routes_days_list)
        ORDER BY u.fio, eta, day_pos) z