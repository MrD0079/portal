/* Formatted on 08.06.2016 15:51:33 (QP5 v5.252.13127.32867) */
SELECT TO_CHAR (MIN (created), 'dd.mm.yyyy') createdmin,
       TO_CHAR (MAX (created), 'dd.mm.yyyy') createdmax
  FROM scmovezay
 WHERE (   tn IN (SELECT slave
                    FROM full
                   WHERE master = :tn)
        OR (SELECT NVL (is_admin, 0)
              FROM user_list
             WHERE tn = :tn) = 1
        OR (SELECT NVL (is_traid, 0)
              FROM user_list
             WHERE tn = :tn) = 1)