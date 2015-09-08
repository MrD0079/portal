/* Formatted on 03/06/2013 8:50:28 (QP5 v5.227.12220.39724) */
SELECT SUM (selected) selected, SUM (sales1) sales1, SUM (sales2) sales2
  FROM (  SELECT v.tab_num,
                 st.fio fio_ts,
                 v.fio_eta,
                 v.tp_ur,
                 v.tp_addr,
                 v.tp_kod,
                 vtps.selected,
                 NVL (vtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = v.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 v.summa_aprel sales1,
                 SUM (v.summa) sales2
            FROM a13_mavk_tp_select vtps, a13_mavk v, user_list st /*,
                                                       (SELECT *
                                                          FROM val_vesna_tp_select
                                                         WHERE m = 3 and selected = 1) cc*/
           WHERE     v.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND v.tp_kod = vtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        /*AND v.tp_kod = cc.tp_kod(+)
        AND cc.tp_kod IS NULL*/
        GROUP BY v.tab_num,
                 st.fio,
                 v.fio_eta,
                 v.tp_ur,
                 v.tp_addr,
                 v.tp_kod,
                 vtps.selected,
                 vtps.contact_lpr,v.summa_aprel)