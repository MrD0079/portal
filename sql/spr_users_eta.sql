/* Formatted on 08/10/2015 11:49:16 (QP5 v5.252.13127.32867) */
  SELECT u.fio,
         u.tn,
         h.id,
         h.h_eta,
         h.eta,
         h.login,
         h.is_eta_kk,
         h.dpt_id,
         h.reserv,
         TO_CHAR (h.reserv_dt, 'dd.mm.yyyy') reserv_dt,
         s.password,
         TO_CHAR (f.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (h.datauvol, 'dd.mm.yyyy') datauvol /*,
          FN_QUERY2STR (
                'SELECT t2.fio FROM emp_exp t1, user_list t2 WHERE t1.emp_tn = '
             || u.tn
             || ' AND t1.exp_tn = t2.tn AND t2.is_coach=1 ORDER BY t2.fio',
             '<br>')
             tr_list*/
    FROM spr_users_eta h,
         spr_users s,
         (  SELECT login, MAX (lu) lu
              FROM full_log
             WHERE login IS NOT NULL
          GROUP BY login) f,
         (SELECT DISTINCT ur.tab_number tab_number, ur.h_eta h_eta
            FROM routes ur
           WHERE ur.tab_number > 0 AND ur.dpt_id = :dpt_id) r,
         user_list u
   WHERE     h.login = S.LOGIN
         AND h.login = f.login(+)
         AND h.dpt_id = :dpt_id
         AND h.h_eta = r.h_eta
         AND u.tab_num = r.tab_number
         AND u.dpt_id = :dpt_id
   and u.is_spd=1
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
                           WHERE master = :tn)
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ( ( :reserv = 1) OR ( :reserv = 2 AND h.reserv = 1))
ORDER BY u.fio, h.eta