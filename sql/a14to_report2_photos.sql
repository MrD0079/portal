/* Formatted on 02/09/2016 10:36:02 (QP5 v5.252.13127.32867) */
SELECT t.url
  FROM a14to t, a14totp s
 WHERE     t.tp_kod_key = :tp_kod
       AND t.visitdate = TO_DATE ( :dt, 'dd.mm.yyyy')
       AND t.url IS NOT NULL
       AND t.visitdate = s.visitdate(+)
       AND t.tp_kod_key = s.tp_kod(+)
       AND (   :standart = 1
            OR ( :standart = 2 AND standart = 'A')
            OR ( :standart = 3 AND standart = 'B'))