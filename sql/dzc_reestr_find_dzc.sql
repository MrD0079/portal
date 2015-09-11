/* Formatted on 11/09/2015 16:10:44 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist,
       NVL (AVG (DECODE (slaves1 + slaves2 + slaves3 + is_do, 0, 0, 1)), 0)
          visible
  FROM (SELECT dzc.id,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn = dzc.tn)
                  slaves1,
               (SELECT COUNT (*)
                  FROM (SELECT DISTINCT slave tn
                          FROM full
                         WHERE master = :tn)
                 WHERE tn IN (SELECT tn
                                FROM dzc_accept
                               WHERE dzc_id = dzc.id))
                  slaves2,
               (SELECT COUNT (*)
                  FROM assist
                 WHERE     child = :tn
                       AND parent IN (SELECT tn
                                        FROM dzc_accept
                                       WHERE dzc_id = dzc.id)
                       AND dpt_id = (SELECT dpt_id
                                       FROM user_list
                                      WHERE tn = dzc.tn))
                  slaves3,
               (SELECT NVL (is_do, 0)
                  FROM user_list
                 WHERE tn = :tn)
                  is_do
          FROM dzc
         WHERE dzc.id = :dzc_id) z