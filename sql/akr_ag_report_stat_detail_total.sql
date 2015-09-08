/* Formatted on 15.02.2013 16:28:30 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c,
       SUM (DECODE (nvl(LENGTH (r.text),0), 0, 0, 1)) text,
       AVG (r.count_byu) count_byu,
       AVG (r.stock_start) stock_start,
       AVG (r.stock_finish) stock_finish,
       AVG (r.stock_shelf) stock_shelf
  FROM akr_tz tz,
       akr_city c,
       akr_diviz d,
       akr_nets n,
       akr_contr_avk cavk,
       akr_contr_ag cag,
       user_list u,
       akr_tz_ag_report r
 WHERE     tz.city = c.id(+)
       AND tz.nets = n.id(+)
       AND tz.diviz = d.id(+)
       AND tz.contr_avk = cavk.id(+)
       AND tz.contr_ag = cag.id(+)
       AND tz.cont_avk = u.tn(+)
       AND tz.id = r.tz_id
       AND r.tz_id = :tz_id
       AND r.dt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')