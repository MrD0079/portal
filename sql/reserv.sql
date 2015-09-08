/* Formatted on 13/11/2014 15:02:59 (QP5 v5.227.12220.39724) */
  SELECT u.*,
         pu.fio chief_fio,
         TO_CHAR (u.res_dt, 'dd.mm.yyyy') res_dt_t,
         FN_QUERY2STR (
               'SELECT t2.fio/*||'' ''||t2.pos_name||'' ''||t2.is_coach*/ FROM emp_exp t1, user_list t2 WHERE t1.emp_tn = '
            || u.tn
            || ' AND t1.exp_tn = t2.tn AND t2.is_coach=1 ORDER BY t2.fio',
            '<br>')
            tr_list
    FROM user_list u, parents p, user_list pu
   WHERE     u.res = 1
         AND p.tn = u.tn
         AND p.parent = pu.tn
         AND u.tn IN
                (SELECT slave
                   FROM full
                  WHERE master =
                           DECODE (:exp_list_without_ts,
                                   0, master,
                                   :exp_list_without_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_coach, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.dpt_id = :dpt_id
         AND DECODE (:res_pos_id, 0, 0, :res_pos_id) =
                DECODE (:res_pos_id, 0, 0, u.res_pos_id)
         AND DECODE (:region_name, '0', '0', :region_name) =
                DECODE (:region_name, '0', '0', u.region_name)
         AND DECODE (:department_name, '0', '0', :department_name) =
                DECODE (:department_name, '0', '0', u.department_name)
ORDER BY u.fio