/* Formatted on 08.06.2016 15:51:21 (QP5 v5.252.13127.32867) */
  SELECT z.*,
         TO_CHAR (z.created, 'dd.mm.yyyy') created,
         TO_CHAR (z.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         u.fio,
         a.name statusname
    FROM scmovezay z, user_list u, accept_types a
   WHERE     (   :exp_list_without_ts = 0
              OR z.tn IN (SELECT slave
                            FROM full
                           WHERE master = :exp_list_without_ts))
         AND (   z.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND z.created BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                           AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
         AND (   :status = 0
              OR ( :status = 1 AND z.status = 0)
              OR ( :status = 2 AND z.status = 1)
              OR ( :status = 3 AND z.status = 2))
         AND (   :tptype = 0
              OR ( :tptype = 1 AND z.tpfrom IS NOT NULL)
              OR ( :tptype = 2 AND z.netfrom IS NOT NULL))
         AND z.tn = u.tn
         AND (   LENGTH ( :zname) = 0
              OR LOWER (
                    z.tpnamefrom || z.netnamefrom || z.tpnameto || z.netnameto) LIKE
                    '%' || LOWER ( :zname) || '%')
         AND z.status = a.id
ORDER BY z.id