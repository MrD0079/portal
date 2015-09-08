/* Formatted on 04.03.2013 11:20:54 (QP5 v5.163.1008.3004) */
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
         u.dpt_name
    FROM user_list u,
         (  SELECT tn, MAX (dev_sol) dev_sol
              FROM ocenka_exp_comment
             WHERE event = TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - 1
          GROUP BY tn) oec,
         (SELECT b.tn
            FROM dc_order_head h, dc_order_body b
           WHERE     h.id = b.head
                 AND manual >= 0
                 AND TRUNC (h.dt_start, 'yyyy') = TRUNC (SYSDATE, 'yyyy')) dc
   WHERE     dc.tn(+) = u.tn
         AND dc.tn IS NULL
         AND dc.tn IS NULL
         AND oec.tn(+) = u.tn
         AND NVL (oec.dev_sol, 0) <> 1
         AND u.is_spd = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND u.dpt_id IN (SELECT dpt_id
                            FROM departments
                           WHERE dpt_id IN (:country) OR DECODE (':country', '0', dpt_id, '0') = dpt_id)
         AND u.pos_id IN (SELECT pos_id
                            FROM user_list
                           WHERE pos_id IN (:pos) OR DECODE (':pos', '0', pos_id, '0') = pos_id AND pos_id IS NOT NULL)
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master IN (:ruk) OR DECODE (':ruk', '0', master, '0') = master)
ORDER BY u.fio, u.start_pos,
         u.start_company