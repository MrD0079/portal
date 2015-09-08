/* Formatted on 17.12.2012 15:42:50 (QP5 v5.163.1008.3004) */
SELECT SUM (sales11) sales11, SUM (sales12) sales12, SUM (selected) selected
  FROM (  SELECT val_dec2012.tab_num,
                 st.fio fio_ts,
                 val_dec2012.fio_eta,
                 val_dec2012.tp_ur,
                 val_dec2012.tp_addr,
                 val_dec2012.tp_kod,
                 tps.ok_traid,
                 tps.selected,
                 NVL (tps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = val_dec2012.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 SUM (CASE WHEN TRUNC (val_dec2012.data, 'mm') = TO_DATE ('01.11.2012', 'dd.mm.yyyy') THEN val_dec2012.summa ELSE 0 END) sales11,
                 SUM (CASE WHEN TRUNC (val_dec2012.data, 'mm') = TO_DATE ('01.12.2012', 'dd.mm.yyyy') THEN val_dec2012.summa ELSE 0 END) sales12
            FROM val_dec2012_tp_select tps, val_dec2012, user_list st
           WHERE     val_dec2012.tab_num = st.tab_num
                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND val_dec2012.tp_kod = tps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY val_dec2012.tab_num,
                 st.fio,
                 val_dec2012.fio_eta,
                 val_dec2012.tp_ur,
                 val_dec2012.tp_addr,
                 val_dec2012.tp_kod,
                 tps.ok_traid,
                 tps.selected,
                 tps.contact_lpr
        ORDER BY st.fio,
                 val_dec2012.fio_eta,
                 val_dec2012.tp_ur,
                 val_dec2012.tp_addr)
 WHERE sales11 >= 950