/* Formatted on 29.07.2013 15:33:02 (QP5 v5.227.12220.39724) */
  SELECT a13_sp7.tab_num,
         st.fio fio_ts,
         a13_sp7.fio_eta,
         a13_sp7.tp_ur,
         a13_sp7.tp_addr,
         a13_sp7.tp_kod,
         a13_sp7tps.selected,
         NVL (a13_sp7tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a13_sp7.tp_kod AND ROWNUM = 1))
            contact_lpr,
           2
         - CASE
              WHEN SUM (NVL (an.if1, 0)) >= 2 THEN 2
              WHEN SUM (NVL (an.if1, 0)) = 1 THEN 1
              WHEN SUM (NVL (an.if1, 0)) <= 0 THEN 0
           END
            max_if1,
           2
         - CASE
              WHEN SUM (NVL (an.if2, 0)) >= 2 THEN 2
              WHEN SUM (NVL (an.if2, 0)) = 1 THEN 1
              WHEN SUM (NVL (an.if2, 0)) <= 0 THEN 0
           END
            max_if2,
           2
         - CASE
              WHEN SUM (NVL (an.if3, 0)) >= 2 THEN 2
              WHEN SUM (NVL (an.if3, 0)) = 1 THEN 1
              WHEN SUM (NVL (an.if3, 0)) <= 0 THEN 0
           END
            max_if3,
         SUM (NVL (an.if1, 0)) if1,
         SUM (NVL (an.if2, 0)) if2,
         SUM (NVL (an.if3, 0)) if3
    FROM a13_sp7_tp_select a13_sp7tps,
         a13_sp7_action_nakl an,
         a13_sp7,
         user_list st
   WHERE     a13_sp7.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a13_sp7.tp_kod = a13_sp7tps.tp_kod
         AND a13_sp7.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL(+)
         AND st.dpt_id = :dpt_id
         AND DECODE (:eta_list, '', a13_sp7.h_fio_eta, :eta_list) =
                a13_sp7.h_fio_eta
         AND a13_sp7tps.selected = 1
         AND a13_sp7.data BETWEEN TO_DATE ('15.07.2013', 'dd.mm.yyyy')
                              AND TO_DATE ('31.07.2013', 'dd.mm.yyyy')
GROUP BY a13_sp7.tab_num,
         st.fio,
         a13_sp7.fio_eta,
         a13_sp7.tp_ur,
         a13_sp7.tp_addr,
         a13_sp7.tp_kod,
         a13_sp7tps.selected,
         a13_sp7tps.contact_lpr
ORDER BY st.fio,
         a13_sp7.fio_eta,
         a13_sp7.tp_ur,
         a13_sp7.tp_addr