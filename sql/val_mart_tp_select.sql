/* Formatted on 11.01.2013 13:54:06 (QP5 v5.163.1008.3004) */
  SELECT val_mart.tab_num,
         val_mart.fio_ts,
         val_mart.fio_eta,
         val_mart.tp_ur,
         val_mart.tp_addr,
         val_mart.tp_kod,
         val_marttps.selected,
         val_marttps.contact_lpr,
         VMK.KAT_NAME,
         val_marttps.tp_kat,
         SUM (CASE WHEN val_mart.data BETWEEN TO_DATE ('01.02.2012', 'dd.mm.yyyy') AND TO_DATE ('29.02.2012', 'dd.mm.yyyy') THEN val_mart.summa ELSE 0 END) sales
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
         AND st.dpt_id = :dpt_id
GROUP BY val_mart.tab_num,
         val_mart.fio_ts,
         val_mart.fio_eta,
         val_mart.tp_ur,
         val_mart.tp_addr,
         val_mart.tp_kod,
         val_marttps.selected,
         val_marttps.contact_lpr,
         VMK.KAT_NAME,
         val_marttps.tp_kat
ORDER BY val_mart.fio_ts,
         val_mart.fio_eta,
         val_mart.tp_ur,
         val_mart.tp_addr