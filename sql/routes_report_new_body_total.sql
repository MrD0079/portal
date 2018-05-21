/* Formatted on 17.05.2018 16:09:53 (QP5 v5.252.13127.32867) */
SELECT SUM (rb.day_enabled_mr) day_enabled_mr,
       SUM (rb.day_time_mr) day_time_mr,
       SUM (NVL (rb.day_enabled_mr, 0)) visits_mr,
       /*SUM (rb.day_enabled_f) day_enabled_f,
       SUM (rb.day_time_f) day_time_f,
       SUM (NVL (rb.day_enabled_f, 0)) visits_f,*/
       SUM (DECODE (NVL (rb.day_enabled_mr, 0) /*+ NVL (rb.day_enabled_f, 0)*/
                                              , 0, 0, 1)) visits
  FROM cpp,
       (SELECT *
          FROM svms_oblast
         WHERE tn = (SELECT tn
                       FROM routes_head
                      WHERE id = :route)) s,
       routes_body1 rb,
       routes_agents a,
       routes_tp rt
 WHERE     cpp.tz_oblast = s.oblast
       AND cpp.kodtp = rb.kodtp(+)
       AND rb.head_id(+) = :route
       AND cpp.kodtp = rt.kodtp
       AND rt.head_id = :route
       AND A.ID = rb.ag_id
       AND rb.day_num = :day
       AND (rb.day_enabled_mr = 1 /*OR rb.day_enabled_f = 1*/
                                 )
       AND rt.vv = 0
       AND rb.vv = 0