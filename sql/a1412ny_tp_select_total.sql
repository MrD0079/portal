/* Formatted on 24/12/2014 13:15:08 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT ny.tab_num,
                 st.fio fio_ts,
                 ny.fio_eta,
                 ny.tp_ur,
                 ny.tp_addr,
                 ny.tp_kod,
                 ny.sales_nov,
                 ny.sales_dec - NVL (z.sales, 0) - NVL (s7.sales, 0) sales_dec,
                 DECODE (a1412nytps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1412nytps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = ny.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1412ny_tp_select a1412nytps,
                 a1412ny ny,
                 user_list st,
                 (  SELECT d.tp_kod_key, SUM (d.sales) sales
                      FROM a1411z d, a1411z_action_nakl an, a1411z_tp_select tp
                     WHERE     d.H_TP_KOD_key_DATA_NAKL =
                                  an.H_TP_KOD_key_DATA_NAKL
                           AND d.tp_kod_key = tp.tp_kod_key
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2014', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod_key) z,
                 (  SELECT d.tp_kod, SUM (d.summnds) sales
                      FROM a1412s7 d,
                           a1412s7_action_nakl an,
                           a1412s7_tp_select tp
                     WHERE     d.H_TP_KOD_DATA_NAKL = an.H_TP_KOD_DATA_NAKL
                           AND d.tp_kod = tp.tp_kod
                           AND TRUNC (d.data, 'mm') =
                                  TO_DATE ('01.12.2014', 'dd.mm.yyyy')
                  GROUP BY d.tp_kod) s7
           WHERE     ny.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND ny.tp_kod = a1412nytps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND ny.tp_kod = z.tp_kod_key(+)
                 AND ny.tp_kod = s7.tp_kod(+)
        ORDER BY st.fio, ny.fio_eta, ny.tp_ur)