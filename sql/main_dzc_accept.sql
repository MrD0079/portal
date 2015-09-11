/* Formatted on 11/09/2015 16:56:23 (QP5 v5.227.12220.39724) */
  SELECT dzc.id,
         TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
         dzc.comm,
         rcy.currencyname,
         rcs.customername,
         rds.departmentname,
         rps.statname,
         rss.producttype,
         dzc.summa,
         c.mt || ' ' || c.y dt,
         dzc.tn creator_tn,
         fn_getname (dzc.tn) creator,
         fn_getname (dzc.recipient) recipient,
         (SELECT tn
            FROM dzc_accept
           WHERE     dzc_id = dzc.id
                 AND accept_order = (SELECT MIN (accept_order)
                                       FROM dzc_accept
                                      WHERE dzc_id = dzc.id AND accepted = 0))
            current_acceptor_tn
    FROM dzc,
         DZC_REFCURRENCY rcy,
         DZC_REFCUSTOMERS rcs,
         DZC_REFDEPARTMENTS rds,
         DZC_REFSTATESOFEXPENCES rps,
         DZC_REFPRODUCTTYPES rss,
         calendar c
   WHERE     (   (SELECT tn
                    FROM dzc_accept
                   WHERE     dzc_id = dzc.id
                         AND accept_order =
                                (SELECT MIN (accept_order)
                                   FROM dzc_accept
                                  WHERE dzc_id = dzc.id AND accepted = 0)) =
                    :tn
              OR dzc.tn = :tn
              OR ( (SELECT accept_order
                      FROM dzc_accept
                     WHERE     dzc_id = dzc.id
                           AND accept_order =
                                  (SELECT MIN (accept_order)
                                     FROM dzc_accept
                                    WHERE dzc_id = dzc.id AND accepted = 0)) >=
                     (SELECT accept_order
                        FROM dzc_accept
                       WHERE dzc_id = dzc.id AND tn = :tn)))
         AND DECODE ( (SELECT COUNT (*)
                         FROM dzc_accept
                        WHERE dzc_id = dzc.id AND accepted = 2),
                     0, 0,
                     1) = 0
         AND NVL (
                (SELECT accepted
                   FROM dzc_accept
                  WHERE     dzc_id = dzc.id
                        AND accept_order =
                               DECODE (
                                  NVL (
                                     (SELECT MAX (accept_order)
                                        FROM dzc_accept
                                       WHERE dzc_id = dzc.id AND accepted = 2),
                                     0),
                                  0, (SELECT MAX (accept_order)
                                        FROM dzc_accept
                                       WHERE dzc_id = dzc.id /* AND accepted <> 0*/
                                                            ),
                                  (SELECT MAX (accept_order)
                                     FROM dzc_accept
                                    WHERE dzc_id = dzc.id AND accepted = 2))),
                0) <> 1
         AND dzc.CURRENCYCODE = rcy.CURRENCYCODE(+)
         AND dzc.CUSTOMERID = rcs.CUSTOMERID(+)
         AND dzc.DEPARTMENTID = rds.DEPARTMENTID(+)
         AND dzc.STATID = rps.STATID(+)
         AND dzc.H_PRODUCTTYPE = rss.H_PRODUCTTYPE(+)
         AND dzc.dt = c.data(+)
         AND (SELECT tn
                FROM dzc_accept
               WHERE     dzc_id = dzc.id
                     AND accept_order =
                            (SELECT MIN (accept_order)
                               FROM dzc_accept
                              WHERE dzc_id = dzc.id AND accepted = 0)) = :tn
ORDER BY dzc.id