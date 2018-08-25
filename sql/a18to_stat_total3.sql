/* Formatted on 10.08.2018 21:52:35 (QP5 v5.252.13127.32867) */
SELECT SUM (bonus4tp) bonus4tp, sum(cto) cto
  FROM (  SELECT tp_kod_key,
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
                    /** DECODE (zst_lu, NULL, 0, 1)
                    * DECODE (reject_traid_in_month, 1, NULL, 1)*/
                    bonus4tp
            FROM (:brief)
        GROUP BY tp_kod_key)