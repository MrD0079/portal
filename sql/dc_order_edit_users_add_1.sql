/* Formatted on 25.07.2013 10:00:19 (QP5 v5.227.12220.39724) */
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
         AND oec.tn(+) = u.tn
         AND NVL (oec.dev_sol, 0) <> 1
         AND u.is_spd = 1
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
ORDER BY u.fio, u.start_pos, u.start_company