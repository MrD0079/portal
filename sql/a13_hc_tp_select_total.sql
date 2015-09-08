/* Formatted on 17.09.2013 16:29:03 (QP5 v5.227.12220.39724) */
SELECT SUM (selected) selected
  FROM (  SELECT a13_hc.tab_num,
                 st.fio fio_ts,
                 a13_hc.fio_eta,
                 a13_hc.tp_ur,
                 a13_hc.tp_kod,
                 a13_hctps.selected,
                 NVL (a13_hctps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a13_hc.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a13_hc_tp_select a13_hctps, a13_hc, user_list st
           WHERE     a13_hc.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a13_hc.tp_kod = a13_hctps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        /*AND a13_hc.data BETWEEN TO_DATE ('01.01.2013', 'dd.mm.yyyy') AND TO_DATE ('12.05.2013', 'dd.mm.yyyy')*/
        GROUP BY a13_hc.tab_num,
                 st.fio,
                 a13_hc.fio_eta,
                 a13_hc.tp_ur,
                 a13_hc.tp_kod,
                 a13_hctps.selected,
                 a13_hctps.contact_lpr)