/* Formatted on 11.01.2013 13:50:29 (QP5 v5.163.1008.3004) */
SELECT z.*,
       DECODE (NVL (sales_fevr, 0), 0, 0, ROUND (sales_mart / sales_fevr * 100, 2) - DECODE (NVL (sales_mart, 0), 0, 0, 1) * 100) perc_mart,
       DECODE (NVL (sales_mart, 0), 0, 0, ROUND (sales_apr / sales_mart * 100, 2) - DECODE (NVL (sales_apr, 0), 0, 0, 1) * 100) perc_apr,
       DECODE (NVL (sales_fevr, 0), 0, 0, ROUND ( (sales_mart + sales_apr) / (sales_fevr * 1.5) * 100, 2) - DECODE (NVL (sales_mart + sales_apr, 0), 0, 0, 1) * 100) perc_total,
       sales_mart + sales_apr - sales_fevr * 1.5 rost_total,
       (sales_mart + sales_apr - sales_fevr * 1.5) / 10 bonus
  FROM (  SELECT val_mart.tab_num,
                 val_mart.fio_ts,
                 val_mart.fio_eta,
                 val_mart.tp_ur,
                 val_mart.tp_addr,
                 val_mart.tp_kod,
                 val_marttps.selected,
                 val_marttps.contact_lpr,
                 vmk.kat_name,
                 val_marttps.tp_kat,
                 SUM (CASE WHEN val_mart.data BETWEEN TO_DATE ('01.02.2012', 'dd.mm.yyyy') AND TO_DATE ('29.02.2012', 'dd.mm.yyyy') THEN val_mart.summa ELSE 0 END) sales_fevr,
                 SUM (CASE WHEN val_mart.data BETWEEN TO_DATE ('15.03.2012', 'dd.mm.yyyy') AND TO_DATE ('31.03.2012', 'dd.mm.yyyy') THEN val_mart.summa ELSE 0 END) sales_mart,
                 SUM (CASE WHEN val_mart.data BETWEEN TO_DATE ('01.04.2012', 'dd.mm.yyyy') AND TO_DATE ('30.04.2012', 'dd.mm.yyyy') THEN val_mart.summa ELSE 0 END) sales_apr
            FROM val_mart_tp_select val_marttps,
                 val_mart,
                 spdtree st,
                 val_mart_kat vmk,
                 a51_action_nakl a5
           WHERE     val_mart.tab_num = st.tab_num
                 AND st.svideninn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND val_mart.tp_kod = val_marttps.tp_kod
                 AND val_marttps.tp_kat = vmk.id(+)
                 AND val_marttps.selected = 1
                 AND val_marttps.tp_kat = :tp_kat
                 AND val_mart.tp_kod = a5.tp_kod(+)
                 AND val_mart.nakl = a5.nakl(+)
                 AND a5.nakl IS NULL
                 AND st.dpt_id = :dpt_id
        GROUP BY val_mart.tab_num,
                 val_mart.fio_ts,
                 val_mart.fio_eta,
                 val_mart.tp_ur,
                 val_mart.tp_addr,
                 val_mart.tp_kod,
                 val_marttps.selected,
                 val_marttps.contact_lpr,
                 vmk.kat_name,
                 val_marttps.tp_kat
        ORDER BY val_mart.fio_ts,
                 val_mart.fio_eta,
                 val_mart.tp_ur,
                 val_mart.tp_addr) z
 WHERE DECODE (:pt,  1, 0,  2, 1,  3, 0) = DECODE (:pt, 1, 0, CASE WHEN ROUND ( (sales_mart + sales_apr) / (sales_fevr * 1.5) * 100, 2) - 100 >= 49.5 THEN 1 ELSE 0 END)