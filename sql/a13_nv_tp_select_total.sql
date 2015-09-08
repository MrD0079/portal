/* Formatted on 24.12.2013 12:32:10 (QP5 v5.227.12220.39724) */
SELECT SUM (selected) selected,
       SUM (salesnov) salesnov,
       SUM (salesdec) salesdec/*,
       SUM (salesdec_all) salesdec_all,
       SUM (sales_act) sales_act*/
  FROM (  SELECT a13_nv.tab_num,
                 st.fio fio_ts,
                 a13_nv.fio_eta,
                 a13_nv.tp_ur,
                 a13_nv.tp_addr,
                 a13_nv.tp_kod,
                 a13_nvtps.selected,
                 NVL (a13_nvtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a13_nv.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 a13_nv.salesnov,
                   a13_nv.salesdec
                 - NVL (hc.summa, 0)
                 - NVL (oy.summa, 0)
                 - NVL (sn.summa, 0)
                    salesdec/*,
                 a13_nv.salesdec salesdec_all,
                 NVL (hc.summa, 0) + NVL (oy.summa, 0) + NVL (sn.summa, 0)
                    sales_act*/
            FROM a13_nv_tp_select a13_nvtps,
                 a13_nv,
                 user_list st,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_hc d, a13_hc_action_nakl an, a13_hc_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) hc,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_oy d, a13_oy_action_nakl an, a13_oy_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) oy,
                 (  SELECT d.tp_kod, SUM (d.summa) summa
                      FROM a13_sn d, a13_sn_action_nakl an, a13_sn_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND an.if1 = 1
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2013', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) sn
           WHERE     a13_nv.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a13_nv.tp_kod = a13_nvtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND a13_nv.tp_kod = hc.tp_kod(+)
                 AND a13_nv.tp_kod = oy.tp_kod(+)
                 AND a13_nv.tp_kod = sn.tp_kod(+)
        ORDER BY st.fio, a13_nv.fio_eta, a13_nv.tp_ur)