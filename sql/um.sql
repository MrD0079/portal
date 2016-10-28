/* Formatted on 27/02/2015 12:00:06 (QP5 v5.227.12220.39724) */
  SELECT um.fio_ts,
         um.tab_num,
         um.fio_eta,
         um.tp_kod,
         um.tp_ur,
         um.tp_addr,
         um.tp_kod_last,
         um.tp_ur_last,
         um.tp_addr_last,
         TO_CHAR (um.time_begin, 'dd.mm.yyyy hh24:mi:ss') time_begin,
         TO_CHAR (um.time_last_update, 'dd.mm.yyyy hh24:mi:ss')
            time_last_update,
         um.ts_visa,
         um.plan_ev,
         um.plan_val,
         um.plan_c1,
         um.plan_c2,
         um.plan_c3,
         TO_CHAR (um.time_first_visit, 'dd.mm.yyyy hh24:mi:ss')
            time_first_visit,
         um.gps_koord,
         TO_CHAR (um.time_last_visit, 'dd.mm.yyyy hh24:mi:ss')
            time_last_visit,
         um.gps_koord_last_visit,
         um.h_eta,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = u.tn))
            chief_fio,
         um.um_posted
    FROM um, user_list u
   WHERE     um.tab_num = u.tab_num
		 and um.dpt_id=u.dpt_id
         AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_coach, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.dpt_id = :dpt_id
         AND (:eta_list is null OR :eta_list = um.h_eta)
         AND um_date = TO_DATE (:dt, 'dd.mm.yyyy')
ORDER BY chief_fio, fio_ts, fio_eta