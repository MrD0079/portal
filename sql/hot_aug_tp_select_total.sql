/* Formatted on 19.07.2012 11:46:19 (QP5 v5.163.1008.3004) */
SELECT SUM (sales7) sales7, SUM (sales8) sales8, SUM (selected) selected
  FROM (  SELECT hot_aug.tab_num,
                 st.fio fio_ts,
                 hot_aug.fio_eta,
                 hot_aug.tp_ur,
                 hot_aug.tp_addr,
                 hot_aug.tp_kod,
                 hot_augtps.selected,
                 NVL (hot_augtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = hot_aug.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 /*hot_augtps.tp_kat,*/
                 SUM (
                    CASE
                       WHEN TRUNC (hot_aug.data, 'mm') =
                               TO_DATE ('01.07.2012', 'dd.mm.yyyy')
                       THEN
                          hot_aug.summa
                       ELSE
                          0
                    END)
                    sales7,
                 SUM (
                    CASE
                       WHEN TRUNC (hot_aug.data, 'mm') =
                               TO_DATE ('01.08.2012', 'dd.mm.yyyy')
                       THEN
                          hot_aug.summa
                       ELSE
                          0
                    END)
                    sales8
            FROM hot_aug_tp_select hot_augtps, hot_aug, user_list st
           WHERE     hot_aug.tab_num = st.tab_num
                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND hot_aug.tp_kod = hot_augtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY hot_aug.tab_num,
                 st.fio,
                 hot_aug.fio_eta,
                 hot_aug.tp_ur,
                 hot_aug.tp_addr,
                 hot_aug.tp_kod,
                 hot_augtps.selected,
                 hot_augtps.contact_lpr)