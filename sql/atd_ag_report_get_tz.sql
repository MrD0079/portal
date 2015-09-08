/* Formatted on 11.02.2013 11:21:59 (QP5 v5.163.1008.3004) */
  SELECT tz.*,
         c.name city_name,
         d.name diviz_name,
         n.name nets_name,
         u.tn cont_avk_tn,
         u.fio cont_avk_fio,
         cavk.fio cavk_fio,
         cag.fio cag_fio,
         u.phone cont_avk_phone,
         cag.phone cag_phone,n.graph
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_avk cavk,
         atd_contr_ag cag,
         user_list u
   WHERE tz.city = c.id(+) AND tz.nets = n.id(+) AND tz.diviz = d.id(+) AND tz.contr_avk = cavk.id(+) AND tz.contr_ag = cag.id(+) AND tz.cont_avk = u.tn(+) AND tz.id = :id
ORDER BY diviz_name,
         nets_name,
         city_name,
         tz.addr