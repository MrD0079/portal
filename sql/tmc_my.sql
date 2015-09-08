/* Formatted on 08.04.2014 11:43:34 (QP5 v5.227.12220.39724) */
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
         fn_getname ( moved) moved_fio,
         t.state_removed,
         TO_CHAR (t.dtr, 'dd.mm.yyyy ') dtr,
         u.fio,
         u.pos_id,
         u.pos_name,
         u.department_name,
         u.region_name,
         t.num_avk,
         t.zakup_price,
         TO_CHAR (t.zakup_dt, 'dd.mm.yyyy ') zakup_dt,
         TO_CHAR (t.buh_dt, 'dd.mm.yyyy ') buh_dt,t.comm
    FROM tmc t, tmcs s, user_list u
   WHERE t.tn = u.tn AND t.tmcs = s.id AND t.removed = 0 AND t.tn = :tn
ORDER BY t.dtv, s.name, t.name