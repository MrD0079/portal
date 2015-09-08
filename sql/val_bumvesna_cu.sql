/* Formatted on 09.04.2013 16:08:17 (QP5 v5.163.1008.3004) */
  SELECT u.fio,
         v.tab_num,
         v.fio_eta,
         v.tp_kod,
         v.tp_ur,
         v.tp_addr,
         COUNT (*) c,
         SUM (summa) summa,
         SUM (bonus_sum) bonus_sum
    FROM val_bumvesna_action_nakl a,
         val_bumvesna_tp_select t,
         val_bumvesna v,
         user_list u
   WHERE (a.if1 = 1 OR a.if2 = 1) AND a.h_tp_kod_data_nakl = v.h_tp_kod_data_nakl AND t.tp_kod = v.tp_kod AND t.selected = 1 AND u.tab_num = v.tab_num
GROUP BY u.fio,
         v.tab_num,
         v.fio_eta,
         v.tp_kod,
         v.tp_ur,
         v.tp_addr
ORDER BY c DESC