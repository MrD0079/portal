/* Formatted on 13/09/2013 14:29:05 (QP5 v5.227.12220.39724) */
  SELECT distinct u.h_eta,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         u.dpt_id,
         u.dpt_name,
         d.sort,
         t.o_max_dt_start_old,
         t.max_dt_start_old,
         t.o_max_dt_start_this_tr,
         t.max_dt_start_this_tr,
         t.tr_ok,
         t.dt_start_new,
         t.f1,
         t.f2,
         pe.chief_fio,
         pe.chief_tn
    FROM (  SELECT tob.h_eta,
                   MAX (toh.dt_start) o_max_dt_start_old,
                   TO_CHAR (MAX (toh.dt_start), 'dd/mm/yyyy') max_dt_start_old,
                   MAX (DECODE (toh.tr, :tr_kod, toh.dt_start, NULL))
                      o_max_dt_start_this_tr,
                   TO_CHAR (MAX (DECODE (toh.tr, :tr_kod, toh.dt_start, NULL)),
                            'dd/mm/yyyy')
                      max_dt_start_this_tr,
                   MAX (DECODE (toh.tr, :tr_kod, 1, 0)) tr_ok,
                   TRUNC (TO_DATE (:dt_start, 'dd.mm.yyyy')) dt_start_new,
                   TRUNC (TO_DATE (:dt_start, 'dd.mm.yyyy')) - MAX (toh.dt_start)
                      f1,
                     ABS (
                          TRUNC (TO_DATE (:dt_start, 'dd.mm.yyyy'))
                        - NVL (MAX (toh.dt_start), SYSDATE - 1000))
                   - (SELECT val_number
                        FROM parameters
                       WHERE     param_name = 'tr_pt_order_users_list_auto'
                             AND dpt_id = u.dpt_id)
                      f2
              FROM tr_pt_order_head toh, tr_pt_order_body tob, user_list u
             WHERE toh.id = tob.head AND tob.manual >= 0 AND u.h_eta = tob.h_eta
          GROUP BY tob.h_eta, u.dpt_id) t,
         user_list u,
         departments d,
         parents_eta pe
   WHERE     u.dpt_id = d.dpt_id
         AND u.h_eta = t.h_eta(+)
         AND u.h_eta = pe.h_eta
         AND u.dpt_id = pe.dpt_id
         AND u.is_eta = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND DECODE (:tr_ok,  1, 0,  0, NVL (t.tr_ok, 0)) = NVL (t.tr_ok, 0)
         AND pe.chief_tn IN
                (SELECT slave
                   FROM full
                  WHERE    master IN (:ruk)
                        OR DECODE (':ruk', '0', master, '0') = master)
         AND NVL (f2, 0) >= 0
         AND u.dpt_id = :dpt_id
ORDER BY NVL (t.tr_ok, 0),
         o_max_dt_start_this_tr,
         o_max_dt_start_old,
         u.fio