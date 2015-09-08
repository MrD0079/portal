/* Formatted on 19.03.2015 11:45:20 (QP5 v5.227.12220.39724) */
SELECT ROWNUM,
       DECODE (ROUND (ROWNUM / 10 - 0.5) * 10 + 1 - ROWNUM, 0, 1, 0)
          draw_head,
       z.*
  FROM (  SELECT u.*
            FROM (SELECT NVL (fn_getname ( su.tn), su.login) fio,
                         su.PASSWORD,
                         su.LOGIN,
                         su.TN,
                         su.ACCESS_OCENKA,
                         DECODE (st.svideninn, NULL, NULL, 1) is_spd,
                         st.*
                    FROM spr_users su
                         LEFT JOIN spdtree st ON su.tn = st.svideninn
                         LEFT JOIN pos p ON p.pos_id = st.pos_id
                         LEFT JOIN pos_kk pk ON pk.pos_id = st.pos_id
                         LEFT JOIN departments d ON st.dpt_id = D.DPT_ID) u/*,
                 emp_exp e*/
           WHERE     u.dpt_id = :dpt_id
                 AND u.is_spd = 1
                 AND u.login IS NOT NULL
                 /*AND e.exp_tn = e.emp_tn
                 AND e.emp_tn = u.tn*/
                 AND DECODE (:flt,
                             0, SYSDATE,
                             1, NVL (u.datauvol, SYSDATE),
                             -1, u.datauvol) =
                        DECODE (:flt,
                                0, SYSDATE,
                                1, SYSDATE,
                                -1, u.datauvol)
        ORDER BY u.fio) z