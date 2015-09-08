/* Formatted on 14/07/2015 10:30:57 (QP5 v5.227.12220.39724) */
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
         fn_getname (moved) moved_fio,
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
         TO_CHAR (t.buh_dt, 'dd.mm.yyyy ') buh_dt,
         t.comm
    FROM tmc t, tmcs s, user_list u
   WHERE     t.tn = u.tn
         AND t.tmcs = s.id
         AND DECODE (:removed,  0, 0,  1, 1,  2, 2,  3, 0) =
                DECODE (:removed,
                        0, NVL (t.removed, 0),
                        1, NVL (t.removed, 0),
                        2, NVL (t.removed, 0),
                        3, 0)
         AND u.dpt_id = DECODE (:country,
                                '0', u.dpt_id,
                                (SELECT dpt_id
                                   FROM departments
                                  WHERE cnt_kod = :country))
         AND DECODE (:owner, 0, 0, :owner) = DECODE (:owner, 0, 0, t.tn)
         AND DECODE (:tmc_pos_id, 0, 0, :tmc_pos_id) =
                DECODE (:tmc_pos_id, 0, 0, pos_id)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', region_name)
         AND DECODE (:department_name, '0', 0, 1) =
                DECODE (
                   :department_name,
                   '0', 0,
                   DECODE (
                      (SELECT COUNT (*)
                         FROM full
                        WHERE     master IN
                                     (SELECT tn
                                        FROM user_list
                                       WHERE DECODE (
                                                :department_name,
                                                '0', '0',
                                                :department_name) =
                                                DECODE (:department_name,
                                                        '0', '0',
                                                        department_name))
                              AND slave = t.tn),
                      0, 0,
                      1))
         AND dtv BETWEEN TO_DATE (:dates_list_t_1, 'dd.mm.yyyy')
                     AND TO_DATE (:dates_list_t_2, 'dd.mm.yyyy')
         AND (   t.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_it, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (LOWER (t.sn) LIKE LOWER ('%' || :sn || '%') OR length(:sn) is null)
ORDER BY t.dtv, u.fio, t.name