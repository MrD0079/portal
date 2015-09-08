/* Formatted on 09/04/2015 17:37:46 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta, r.eta
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
ORDER BY r.eta