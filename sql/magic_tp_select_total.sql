/* Formatted on 11.01.2013 13:24:05 (QP5 v5.163.1008.3004) */
SELECT NVL (SUM (v.selected), 0) selected,
       NVL (SUM (v.jan_plan), 0) jan_plan,
       SUM (s.v31122011 * 0.7 * DECODE (NVL (v.selected, 0), 0, 0, 1)) december,
       SUM (s.v31012012 * DECODE (NVL (v.selected, 0), 0, 0, 1)) january,
       SUM (s.avg6 * DECODE (NVL (v.selected, 0), 0, 0, 1)) avg6,
       COUNT (*) total
  FROM sh_o_2011 s, magic_tp_select v, spdtree st
 WHERE     s.tab_number = st.tab_num
       AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
       AND s.kod_tp = v.kod_tp(+)
       AND st.dpt_id = :dpt_id