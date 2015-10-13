/* Formatted on 08/10/2015 17:45:16 (QP5 v5.252.13127.32867) */
SELECT NVL (is_red, DECODE (ROUND (ROWNUM / 2) * 2, ROWNUM, 1, 0)) color,
       z.*,
       z.day_pos day,
       z.h_day_pos h_day
  FROM (  SELECT DISTINCT
                 u.tn,
                 u.fio ts,
                 r.ADDRESS,
                 r.CONTACT_FIO,
                 r.CONTACT_TEL,
                 r.DAY_POS,
                 r.h_day_pos,
                 r.ETA,
                 r.H_ETA,
                 r.NTO,
                 r.STELAG,
                 r.TAB_NUMBER,
                 r.TP_KOD,
                 r.TP_NAME,
                 r.TP_PLACE,
                 r.TP_ROUTE_NUM,
                 r.TP_TYPE,
                 r.TUMB,
                 CASE
                    WHEN     r.day_pos = '0. ТП не в маршруте'
                         AND r.tp_type NOT IN ('Предприятия и Профсоюзы (п/п)',
                                               'HoReCa (HRK)',
                                               'Магазин на АЗС (азс)',
                                               'Сезонное Торговое Предприятие (сезон)')
                    THEN
                       2
                 END
                    is_red,
                 r.latitude,
                 r.longitude,
                    '{num: "'
                 || r.tp_route_num
                 || '", name:"№'
                 || r.tp_route_num
                 || '. '
                 || r.tp_kod
                 || '\n'
                 || r.tp_name
                 || '\n'
                 || r.address
                 || DECODE (r.contact_tel, NULL, NULL, '\n' || contact_tel)
                 || DECODE (r.contact_fio, NULL, NULL, '\n' || contact_fio)
                 || '",latlng:new google.maps.LatLng('
                 || REPLACE (r.latitude, ',', '.')
                 || ','
                 || REPLACE (r.longitude, ',', '.')
                 || ')},'
                    googledata
            FROM routes r, full w, user_list u
           WHERE     r.olstatus = 1
                 AND r.dpt_id = u.dpt_id
                 AND r.tab_number = u.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND (   w.master = DECODE ( :tn,
                                            -1, (SELECT MAX (tn)
                                                   FROM user_list
                                                  WHERE is_admin = 1),
                                            :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_super, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_kpr, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND u.datauvol IS NULL
                 AND u.tn IN (SELECT slave
                                FROM full
                               WHERE master =
                                        DECODE (
                                           :exp_list_without_ts,
                                           0, DECODE (
                                                 :tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                           :exp_list_without_ts))
                 AND u.tn IN (SELECT slave
                                FROM full
                               WHERE master =
                                        DECODE (
                                           :exp_list_only_ts,
                                           0, DECODE (
                                                 :tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                           :exp_list_only_ts))
                 AND DECODE ( :routes_eta_list, '', r.h_eta, :routes_eta_list) =
                        r.h_eta
                 AND md5hash (day_pos) IN ( :routes_days_list)
        ORDER BY u.fio,
                 eta,
                 day_pos,
                 tp_route_num,
                 tp_name) z