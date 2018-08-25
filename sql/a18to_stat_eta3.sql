/* Formatted on 12.08.2018 12:31:45 (QP5 v5.252.13127.32867) */
  SELECT key, SUM (bonus4tp) bonus4tp, SUM (cto) cto
    FROM (  SELECT h_fio_eta key,
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
                      /*type_standart_price * DECODE (zst_lu, NULL, 0, 1) * DECODE (reject_traid_in_month, 1, null, 1)*/
                      bonus4tp
              FROM (:brief)
          GROUP BY h_fio_eta, tp_kod_key)
GROUP BY key