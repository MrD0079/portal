/* Formatted on 14.02.2017 16:56:32 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) total,
       SUM (summa) summa,
       SUM (summafact) summafact,
       SUM (acceptstatus) acceptstatus,
       SUM (sendstatus) sendstatus,
       sum (totalSales) summaSales
  FROM (  SELECT r.*,
                 fn_getname (n.tn_mkk) mkk,
                 fn_getname (n.tn_rmkk) rmkk,
                 TO_CHAR (r.acceptstatuslu, 'dd.mm.yyyy hh24:mi:ss')
                    acceptstatuslut,
                 (SELECT COUNT (*)
                    FROM rzayfiles
                   WHERE rzay = r.id)
                    fcount,
                 p.name payer_name,
                 n.net_name,
                 c.mt || ' ' || c.y period,
                 (CASE
                       WHEN NVL(s.TOTALSALES,0) > 0
                       THEN s.TOTALSALES / 1000
                       ELSE 0
                 END) AS TOTALSALES
            FROM rzay r,
                 nets n,
                 bud_fil p,
                 calendar c,
                 (SELECT m.tp_kod, SUM(m.summa) AS totalSales
                  FROM a14mega m
                  WHERE TO_DATE('01.'||m.m||'.'||m.y ,'dd.mm.yyyy')
                              BETWEEN add_months(trunc(TO_DATE ('01.06.2019', 'dd.mm.yyyy'),'mm'),-1)
                              AND last_day(add_months(trunc(TO_DATE ( '30.06.2019', 'dd.mm.yyyy'),'mm'),-1))
                  GROUP BY m.tp_kod
                  ) s
           WHERE     c.data = r.dt
                 AND n.id_net = r.id_net
                 AND r.tp = s.tp_kod(+)
                 AND r.payer = p.id
                 AND DECODE ( :tn_rmkk, 0, n.tn_rmkk, :tn_rmkk) = n.tn_rmkk
                 AND DECODE ( :tn_mkk, 0, n.tn_mkk, :tn_mkk) = n.tn_mkk
                 AND DECODE ( :nets, 0, n.id_net, :nets) = n.id_net
                 AND n.tn_mkk IN (SELECT slave
                                    FROM full
                                   WHERE master = :tn)
                 AND r.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                              AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND ( :sendstatus = 0 OR :sendstatus = r.sendstatus + 1)
                 AND ( :acceptstatus = 0 OR :acceptstatus = r.acceptstatus + 1)
        ORDER BY r.dt, payer_name, net_name) z