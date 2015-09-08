/* Formatted on 28.02.2013 9:05:47 (QP5 v5.163.1008.3004) */
  SELECT z.*, CASE WHEN DECODE (summa_prev, 0, 0, summa / summa_prev * 100 - 100) >= 20 AND summa_prev >= 990 THEN 1 ELSE 0 END green
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
                   SUM (DECODE (TRUNC (v.data, 'mm'), TO_DATE ('01.' || TO_CHAR (:month - 1) || '.2013', 'dd.mm.yyyy'), summa, 0)) summa_prev,
                   SUM (DECODE (TRUNC (v.data, 'mm'), TO_DATE ('01.' || TO_CHAR (:month) || '.2013', 'dd.mm.yyyy'), summa, 0)) summa
              FROM val_vesna_tp_select vtps,
                 val_vesna v,
                 user_list st,
                 creamcherry_action_nakl cc,
                 --val_bumvesna_tp_select vb,
                 choco_action_nakl ch
           WHERE     v.tab_num = st.tab_num
                 AND (st.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND v.tp_kod = vtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND v.h_tp_kod_data_nakl = cc.h_tp_kod_data_nakl(+)
                 --AND v.tp_kod = vb.tp_kod(+)
                 AND v.h_tp_kod_data_nakl = ch.h_tp_kod_data_nakl(+)
                 AND (cc.h_tp_kod_data_nakl IS NULL OR DECODE (NVL (cc.if1, 0) + NVL (cc.if2, 0), 0, 0, 1) = 0)
                 --AND NVL (vb.selected,0) = 0
                 AND ch.h_tp_kod_data_nakl IS NULL
                 AND vtps.m(+) = :month
        GROUP BY v.tab_num,
                   st.fio,
                   v.fio_eta,
                   v.tp_ur,
                   v.tp_addr,
                   v.tp_kod,
                   vtps.selected,
                   vtps.contact_lpr) z
   WHERE summa_prev >= 990
ORDER BY fio_ts, fio_eta, tp_ur