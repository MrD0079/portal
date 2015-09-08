/* Formatted on 11.01.2013 13:54:14 (QP5 v5.163.1008.3004) */
SELECT NVL (SUM (selected), 0) selected
  FROM (SELECT DISTINCT val_marttps.tp_kod, val_marttps.selected
          FROM val_mart_tp_select val_marttps,
               val_mart,
               spdtree st,
               val_mart_kat vmk
         WHERE     val_mart.tab_num = st.tab_num
               AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
               AND val_mart.tp_kod = val_marttps.tp_kod(+)
               AND val_marttps.tp_kat = vmk.id(+)
               AND val_marttps.selected = 1
               AND st.dpt_id = :dpt_id)