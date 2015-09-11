/* Formatted on 11/09/2015 16:17:06 (QP5 v5.227.12220.39724) */
SELECT u.dpt_name,
       TO_CHAR (dzc.created, 'dd.mm.yyyy hh24:mi:ss') created,
       dzc.comm,
       dzc.id,
       rcy.currencyname,
       rcs.customername,
       rds.departmentname,
       rps.statname,
       rss.producttype,
       dzc.currencycode,
       dzc.customerid,
       dzc.departmentid,
       dzc.statid,
       dzc.h_producttype,
       dzc.summa,
       TO_CHAR (dzc.dt, 'yyyymmdd') dt,
       fn_getname (dzc.tn) creator,
       DECODE (  (SELECT COUNT (*)
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id)
               - (SELECT COUNT (*)
                    FROM dzc_accept
                   WHERE dzc_id = dzc.id AND accepted = 1),
               0, 1,
               0)
          dzc_ok,
       u.pos_name creator_pos_name,
       u.department_name creator_department_name
  FROM dzc,
       user_list u,
       dzc_refcurrency rcy,
       dzc_refcustomers rcs,
       dzc_refdepartments rds,
       dzc_refstatesofexpences rps,
       dzc_refproducttypes rss
 WHERE     dzc.id = (SELECT dzc_id
                       FROM dzc_accept
                      WHERE id = :accept_id)
       AND dzc.tn = u.tn
       AND dzc.currencycode = rcy.currencycode(+)
       AND dzc.customerid = rcs.customerid(+)
       AND dzc.departmentid = rds.departmentid(+)
       AND dzc.statid = rps.statid(+)
       AND dzc.h_producttype = rss.h_producttype(+)