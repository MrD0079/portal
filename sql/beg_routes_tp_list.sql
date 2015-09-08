/* Formatted on 07/04/2015 11:34:26 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT tp_kod, tp_name || ', ' || address name, br.tp
    FROM routes r,
         (SELECT b.tp
            FROM beg_routes_head h, beg_routes_body b
           WHERE     h.id = b.head_id
                 AND tn = :tn
                 AND dt = TO_DATE (:dt, 'dd.mm.yyyy')) br,
         departments d
   WHERE     (   tab_number IN (SELECT tab_num
                                  FROM user_list
                                 WHERE tn IN (:ts_list))
              OR h_eta IN (:eta_list)
              OR r.tp_kod IN
                    (SELECT b.tp
                       FROM beg_routes_head h, beg_routes_body b
                      WHERE     h.id = b.head_id
                            AND tn = :tn
                            AND dt = TO_DATE (:dt, 'dd.mm.yyyy')))
         AND r.tp_kod = br.tp(+)
         AND d.manufak = r.country
         AND d.dpt_id = :dpt_id
ORDER BY name