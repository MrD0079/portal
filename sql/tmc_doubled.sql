/* Formatted on 14/07/2015 11:58:14 (QP5 v5.227.12220.39724) */
  SELECT u.fio,
         u.pos_name,
         TO_CHAR (t.dtv, 'dd.mm.yyyy ') dtv,
         t.sn,
         t.num_avk,
         s.name tmcs,
         t.name,
         t.state
    FROM tmc t, user_list u, tmcs s
   WHERE     t.sn IN (  SELECT sn
                          FROM tmc
                         WHERE sn IS NOT NULL AND removed = 0
                      GROUP BY sn
                        HAVING COUNT (*) > 1)
         AND u.tn = t.tn
         AND t.tmcs = s.id
ORDER BY t.sn,
         t.dtv,
         s.name,
         t.name,
         u.fio