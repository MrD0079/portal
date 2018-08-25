/* Formatted on 12.08.2018 12:48:18 (QP5 v5.252.13127.32867) */
  SELECT key, SUM (bonus4tp) bonus4tp, sum(cto) cto
    FROM (  SELECT DISTINCT
                   tn_rm key,
                   tp_kod_key,
                   SUM (cto) cto,
                   CASE
                      WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                              'Стандарт А'
                      THEN
                         60
                      WHEN wm_concat (DISTINCT NVL (standart_tp, 'null')) =
                              'Стандарт А (минимум)'
                      THEN
                         10
                   END
                      bonus4tp
              FROM (:brief)
          GROUP BY tn_rm, tp_kod_key)
GROUP BY key