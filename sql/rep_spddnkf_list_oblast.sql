/* Formatted on 01/06/2016 11:15:12 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT h_tz_oblast, tz_oblast
    FROM cpp
   WHERE id_net IN (SELECT id_net
                      FROM ms_nets
                     WHERE net_name IN ('АТБ',
                                        'МЕТРО',
                                        'Фоззи',
                                        'Фора',
                                        'Сильпо'))
ORDER BY tz_oblast