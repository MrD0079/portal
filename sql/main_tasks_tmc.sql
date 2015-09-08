/* Formatted on 26.02.2014 11:28:03 (QP5 v5.227.12220.39724) */
  SELECT t.id,
         t.name,
         t.sn,
         t.state,
         TO_CHAR (t.dtv, 'dd.mm.yyyy ') dtv,
         s.name tmcs,
         t.add_fio,
         TO_CHAR (t.add_lu, 'dd.mm.yyyy hh24:mi:ss') add_lu,
         t.removed_fio,
         TO_CHAR (t.removed_lu, 'dd.mm.yyyy hh24:mi:ss') removed_lu,
         TO_CHAR (t.accepted_lu, 'dd.mm.yyyy hh24:mi:ss') accepted_lu,
         t.removed,
         t.moved,
         t.state_removed,
         TO_CHAR (t.dtr, 'dd.mm.yyyy ') dtr
    FROM tmc t, tmcs s
   WHERE     t.tn = :tn
         AND t.tmcs = s.id
         AND t.accepted IS NULL
         AND t.removed = 0
ORDER BY t.id