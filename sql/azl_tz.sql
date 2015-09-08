/* Formatted on 20.02.2013 12:38:38 (QP5 v5.163.1008.3004) */
  SELECT tz.*,
         c.name city_name,
         d.name diviz_name,
         n.name nets_name,
         u.tn cont_avk_tn,
         u.fio cont_avk_fio,
         cavk.fio cavk_fio,
         cag.fio cag_fio
    FROM azl_tz tz,
         azl_city c,
         azl_diviz d,
         azl_nets n,
         azl_contr_avk cavk,
         azl_contr_ag cag,
         user_list u
   WHERE tz.city = c.id(+) AND tz.nets = n.id(+) AND tz.diviz = d.id(+) AND tz.contr_avk = cavk.id(+) AND tz.contr_ag = cag.id(+) AND tz.cont_avk = u.tn(+)
ORDER BY diviz_name,
         nets_name,
         city_name,
         tz.addr