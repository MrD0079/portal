/* Formatted on 16.06.2014 16:08:55 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
         u.tab_num,
         u.fio,
         u.pos_name,
         u.pos_id,
         TO_CHAR (u.start_pos, 'dd/mm/yyyy') start_pos,
         TO_CHAR (u.start_company, 'dd/mm/yyyy') start_company,
         u.start_pos o_start_pos,
         u.start_company o_start_company,
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
         t.f2
    FROM (  SELECT tob.tn,
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
                       WHERE     param_name = 'tr_order_users_list_auto'
                             AND dpt_id = u.dpt_id)
                      f2
              FROM tr_order_head toh, tr_order_body tob, user_list u
             WHERE toh.id = tob.head AND tob.manual >= 0 AND u.tn = tob.tn
          GROUP BY tob.tn, u.dpt_id) t,
         user_list u,
         departments d
   WHERE     u.dpt_id = d.dpt_id
         AND u.tn = t.tn(+)
         AND u.is_spd = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND DECODE (:tr_ok,  1, 0,  0, NVL (t.tr_ok, 0)) = NVL (t.tr_ok, 0)
         AND u.dpt_id IN
                (SELECT dpt_id
                   FROM departments
                  WHERE    dpt_id IN (:country)
                        OR DECODE (':country', '0', dpt_id, '0') = dpt_id)
         AND u.pos_id IN
                (SELECT pos_id
                   FROM user_list
                  WHERE     (   pos_id IN (:pos)
                             OR DECODE (':pos', '0', pos_id, '0') = pos_id)
                        AND pos_id IS NOT NULL)
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE    master IN (:ruk)
                        OR DECODE (':ruk', '0', master, '0') = master)
         AND NVL (f2, 0) >= 0
         /*AND u.dpt_id = :dpt_id*/
         AND (SELECT DECODE (COUNT (c1.data), 0, 0, 1)
                FROM vacation v, calendar c1
               WHERE     NVL (
                            (SELECT accepted
                               FROM sz_accept
                              WHERE     sz_id = v.sz_id
                                    AND accept_order =
                                           DECODE (
                                              NVL (
                                                 (SELECT accept_order
                                                    FROM sz_accept
                                                   WHERE     sz_id = v.sz_id
                                                         AND accepted = 464262),
                                                 0),
                                              0, (SELECT MAX (accept_order)
                                                    FROM sz_accept
                                                   WHERE sz_id = v.sz_id),
                                              (SELECT accept_order
                                                 FROM sz_accept
                                                WHERE     sz_id = v.sz_id
                                                      AND accepted = 464262))),
                            0) = 464261
                     AND c1.data BETWEEN v.v_from AND v.v_to
                     AND v.tn = u.tn
                     AND t.dt_start_new = c1.data) = 0
ORDER BY NVL (t.tr_ok, 0),
         DECODE (NVL (t.tr_ok, 0),
                 0, o_start_pos,
                 1, o_max_dt_start_this_tr),
         DECODE (NVL (t.tr_ok, 0),
                 0, o_start_company,
                 1, o_max_dt_start_old),
         o_start_pos,
         o_start_company