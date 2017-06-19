/* Formatted on 07/04/2015 11:35:16 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT r.h_eta, r.eta
    FROM routes r,
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
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY r.eta