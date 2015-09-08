/* Formatted on 13.02.2013 15:21:21 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT tz.*,
                  c.name city_name,
                  d.name diviz_name,
                  n.name nets_name,
                  u.tn cont_avk_tn,
                  u.fio cont_avk_fio,
                  cavk.fio cavk_fio,
                  cag.fio cag_fio,
                  u.phone cont_avk_phone,
                  cag.phone cag_phone
    FROM akr_tz tz,
         akr_city c,
         akr_diviz d,
         akr_nets n,
         akr_contr_avk cavk,
         akr_contr_ag cag,
         user_list u,
         akr_tz_report r
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_avk = cavk.id(+)
         AND tz.contr_ag = cag.id(+)
         AND tz.cont_avk = u.tn(+)
         AND tz.id = r.tz_id
         AND r.tz_id = DECODE (:tz_id, 0, r.tz_id, :tz_id)
         AND tz.nets = DECODE (:nets, 0, tz.nets, :nets)
         AND tz.diviz = DECODE (:diviz, 0, tz.diviz, :diviz)
         AND tz.city = DECODE (:city, 0, tz.city, :city)
         AND r.dt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
         AND (:login IN (cavk.login, TO_CHAR (cavk.inn))
              OR NVL ( (SELECT is_super
                          FROM akr_contr_avk
                         WHERE :login IN (login, TO_CHAR (inn))),
                      0) = 1)
ORDER BY diviz_name,
         nets_name,
         city_name,
         tz.addr