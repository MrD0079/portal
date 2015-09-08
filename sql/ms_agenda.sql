/* Formatted on 08/09/2014 18:06:09 (QP5 v5.227.12220.39724) */
  SELECT /*r.rh_id,*/
         r.rb_kodtp,
         /*c.my,
         c.mt || ' ' || c.y dt,*/
         fn_getname ( r.rh_tn) svms_name,
         r.rh_num num,
         r.rh_fio_otv fio_otv,
         r.cpp1_tz_oblast tz_oblast,
         r.cpp1_city city,
         r.n_net_name net_name,
         r.cpp1_ur_tz_name ur_tz_name,
         r.cpp1_tz_address tz_address,
         r.ra_name ag_name,
         COUNT (*) visits_total,
         SUM (CASE WHEN c1.dw = 1 THEN 1 ELSE 0 END) d1,
         SUM (CASE WHEN c1.dw = 2 THEN 1 ELSE 0 END) d2,
         SUM (CASE WHEN c1.dw = 3 THEN 1 ELSE 0 END) d3,
         SUM (CASE WHEN c1.dw = 4 THEN 1 ELSE 0 END) d4,
         SUM (CASE WHEN c1.dw = 5 THEN 1 ELSE 0 END) d5,
         SUM (CASE WHEN c1.dw = 6 THEN 1 ELSE 0 END) d6,
         SUM (CASE WHEN c1.dw = 7 THEN 1 ELSE 0 END) d7
    FROM ms_rep_routes1 r, calendar c, calendar c1
   WHERE     (   r.rh_tn IN (SELECT emp_tn
                               FROM who_full
                              WHERE exp_tn = :tn)
              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1 OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND r.rh_data = c.data
         AND r.rb_data = c1.data
         AND r.vv = 0
         AND (   (r.rb_data IN (TO_DATE (:ed, 'dd.mm.yyyy')) AND :period = 1)
              OR (    r.rb_data IN
                         (SELECT c2.data
                            FROM calendar c1, calendar c2
                           WHERE     c1.data = TO_DATE (:ed, 'dd.mm.yyyy')
                                 AND c1.y = c2.y
                                 AND c1.wy = c2.wy)
                  AND :period = 2)
              OR (    r.rb_data IN
                         (SELECT data
                            FROM calendar
                           WHERE TRUNC (data, 'mm') =
                                    TO_DATE (:ed, 'dd.mm.yyyy'))
                  AND :period = 3))
         AND DECODE (:svms_list, 0, 0, r.rh_tn) =
                DECODE (:svms_list, 0, 0, :svms_list)
         AND DECODE (:agent, 0, 0, r.rb_ag_id) = DECODE (:agent, 0, 0, :agent)
         AND DECODE (:nets, 0, 0, r.n_id_net) = DECODE (:nets, 0, 0, :nets)
         AND DECODE (:oblast, '0', '0', r.cpp1_tz_oblast) =
                DECODE (:oblast, '0', '0', :oblast)
         AND DECODE (:city, '0', '0', r.cpp1_city) =
                DECODE (:city, '0', '0', :city)      /*AND DECODE (:select_route_numb, 0, 0, r.rh_id) =
       DECODE (:select_route_numb, 0, 0, :select_route_numb)
AND DECODE (:select_route_fio_otv, 0, 0, r.rh_id) =
       DECODE (:select_route_fio_otv, 0, 0, :select_route_fio_otv)*/
GROUP BY /*r.rh_id,*/
         r.rb_kodtp,
         /*c.my,
         c.mt,
         c.y,*/
         r.rh_tn,
         r.rh_num,
         r.rh_fio_otv,
         r.cpp1_tz_oblast,
         r.cpp1_city,
         r.n_net_name,
         r.cpp1_ur_tz_name,
         r.cpp1_tz_address,
         r.ra_name
ORDER BY /*c.y,
         c.my,*/
         svms_name,
         num,
         fio_otv,
         tz_oblast,
         city,
         net_name,
         ur_tz_name,
         tz_address,
         ag_name