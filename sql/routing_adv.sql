/* Formatted on 09/04/2015 17:38:05 (QP5 v5.227.12220.39724) */
  SELECT DECODE (
            GROUPING (
               DECODE (
                  day_pos,
                  '0. ТП не в маршруте', 'Не в маршруте',
                  'В маршруте')),
            0, 'Data',
            'Total')
            in_route_gr,
         DECODE (GROUPING (day_pos), 0, 'Data', 'Total') day_gr,
         DECODE (GROUPING (eta), 0, 'Data', 'Total') eta_gr,
         DECODE (
            GROUPING (
               DECODE (
                  day_pos,
                  '0. ТП не в маршруте', 'Не в маршруте',
                  'В маршруте')),
            0, TO_CHAR (
                  DECODE (
                     day_pos,
                     '0. ТП не в маршруте', 'Не в маршруте',
                     'В маршруте')),
            'Total_in_route')
            in_route_t,
         DECODE (GROUPING (day_pos), 0, TO_CHAR (day_pos), 'Total_day') day_t,
         DECODE (GROUPING (eta), 0, TO_CHAR (eta), 'Total_eta') eta_t,
         COUNT (tp_kod) tp_cnt,
         COUNT (
            DISTINCT DECODE (
                        day_pos,
                        '0. ТП не в маршруте', 'Не в маршруте',
                        'В маршруте'))
            in_route_cnt,
         COUNT (DISTINCT day_pos) day_cnt,
         COUNT (DISTINCT eta) eta_cnt
    FROM (SELECT DISTINCT tp_kod, eta, day_pos
            FROM routes r, full w, user_list u
           WHERE     r.olstatus = 1
                 AND r.dpt_id = u.dpt_id
                 AND r.tab_number = u.tab_num
                 AND u.dpt_id = :dpt_id
                 AND u.tn = w.slave
                 AND (   w.master = DECODE (:tn,
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
                 AND u.tn IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (
                                      :exp_list_without_ts,
                                      0, DECODE (:tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                      :exp_list_without_ts))
                 AND u.tn IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (
                                      :exp_list_only_ts,
                                      0, DECODE (:tn,
                                                 -1, (SELECT MAX (tn)
                                                        FROM user_list
                                                       WHERE is_admin = 1),
                                                 :tn),
                                      :exp_list_only_ts))
                 AND DECODE (:routes_eta_list, '', r.h_eta, :routes_eta_list) =
                        r.h_eta
                 AND md5hash(day_pos) IN (:routes_days_list))
GROUP BY CUBE (eta,
               day_pos,
               DECODE (
                  day_pos,
                  '0. ТП не в маршруте', 'Не в маршруте',
                  'В маршруте'))
ORDER BY GROUPING (
            DECODE (
               day_pos,
               '0. ТП не в маршруте', 'Не в маршруте',
               'В маршруте')) DESC,
         GROUPING (day_pos) DESC,
         GROUPING (eta) DESC,
         DECODE (
            day_pos,
            '0. ТП не в маршруте', 'Не в маршруте',
            'В маршруте'),
         day_pos,
         eta