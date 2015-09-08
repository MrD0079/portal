/* Formatted on 25/11/2014 16:06:47 (QP5 v5.227.12220.39724) */
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
         u.fio moved_fio,
         t.state_removed,
         TO_CHAR (t.dtr, 'dd.mm.yyyy ') dtr,
         t.num_avk,
         t.zakup_price,
         TO_CHAR (t.zakup_dt, 'dd.mm.yyyy ') zakup_dt,
         TO_CHAR (t.buh_dt, 'dd.mm.yyyy ') buh_dt,t.comm
    FROM tmc t, tmcs s, user_list u
   WHERE t.tn = :tn AND t.tmcs = s.id AND t.moved = u.tn(+)
ORDER BY t.dtv, t.name