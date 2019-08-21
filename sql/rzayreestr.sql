/* Formatted on 14.02.2017 16:56:24 (QP5 v5.252.13127.32867) */
  SELECT r.*,
         fn_getname (n.tn_mkk) mkk,
         fn_getname (n.tn_rmkk) rmkk,
         TO_CHAR (r.acceptstatuslu, 'dd.mm.yyyy hh24:mi:ss') acceptstatuslut,
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
         END) AS TOTALSALES,
         (CASE
               WHEN NVL(s.TOTALSALES,0) > 0
               /*THEN ROUND((NVL(r.summafact,0)*1000 / NVL(s.TOTALSALES,1) * 100),3)*/
               THEN ROUND((NVL(r.summa,0)*1000 / NVL(s.TOTALSALES,1) * 100),3)
               ELSE 0
         END) AS persentSumma
    FROM rzay r,
         nets n,
         bud_fil p,
         calendar c,
         (SELECT m.tp_kod, SUM(m.summa) AS totalSales
          FROM a14mega m
          WHERE TO_DATE('01.'||m.m||'.'||m.y ,'dd.mm.yyyy')
                      BETWEEN add_months(trunc(TO_DATE ( :sd, 'dd.mm.yyyy'),'mm'),-1)
                      AND last_day(add_months(trunc(TO_DATE ( :sd, 'dd.mm.yyyy'),'mm'),-1))
          GROUP BY M.tp_kod
          ) s
   WHERE     c.data = r.dt
         AND n.id_net = r.id_net
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
         AND r.TP = s.TP_KOD(+)
ORDER BY r.dt, payer_name, net_name