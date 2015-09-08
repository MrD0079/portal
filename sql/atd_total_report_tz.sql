/* Formatted on 21.02.2013 8:39:13 (QP5 v5.163.1008.3004) */
  SELECT tz.*,
         c.name city_name,
         d.name diviz_name,
         n.name nets_name,
         u.tn cont_avk_tn,
         u.fio cont_avk_fio,
         cavk.fio cavk_fio,
         cag.fio cag_fio,
         u.phone cont_avk_phone,
         cag.phone cag_phone,
         cavk.phone cavk_phone
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_avk cavk,
         atd_contr_ag cag,
         user_list u
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_avk = cavk.id(+)
         AND tz.contr_ag = cag.id(+)
         AND tz.cont_avk = u.tn(+)
         AND tz.id = DECODE (:tz_id, 0, tz.id, :tz_id)
         AND tz.nets = DECODE (:nets, 0, tz.nets, :nets)
         AND tz.diviz = DECODE (:diviz, 0, tz.diviz, :diviz)
         AND tz.city = DECODE (:city, 0, tz.city, :city)
         AND tz.contr_avk = DECODE (:atd_contr_avk, 0, tz.contr_avk, :atd_contr_avk)
         AND tz.contr_ag = DECODE (:atd_contr_ag, 0, tz.contr_ag, :atd_contr_ag)
         AND tz.id IN (SELECT tz.id
                         FROM atd_tz tz,
                              atd_nets an,
                              nets n,
                              atd_contr_avk aca
                        WHERE     tz.nets = an.id
                              AND an.kod = n.sw_kod(+)
                              AND tz.contr_avk = aca.id(+)
                              AND   DECODE ( (SELECT DECODE (NVL (is_mkk, 0) + NVL (is_rmkk, 0), 0, 0, 1)
                                                FROM user_list
                                               WHERE tn = :tn)
                                            + DECODE (DECODE (n.tn_mkk, :tn, 1, 0) + DECODE (n.tn_rmkk, :tn, 1, 0), 0, 0, 1),
                                            2, 1,
                                            0)
                                  + DECODE (aca.inn, :tn, 1, 0)
                                  + (SELECT is_super
                                       FROM atd_contr_avk
                                      WHERE inn = :tn) <> 0)
ORDER BY diviz_name,
         city_name,
         nets_name,
         tz.addr