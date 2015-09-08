/* Formatted on 29/01/2015 12:13:44 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a150221ngs.tab_num,
                 st.fio fio_ts,
                 a150221ngs.fio_eta,
                 a150221ngs.tp_ur,
                 a150221ngs.tp_addr,
                 a150221ngs.tp_kod,
                 DECODE (a150221ngstps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a150221ngstps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a150221ngs.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a150221ngs_tp_select a150221ngstps, a150221ngs, user_list st
           WHERE     a150221ngs.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a150221ngs.tp_kod = a150221ngstps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a150221ngs.tab_num,
                 st.fio,
                 a150221ngs.fio_eta,
                 a150221ngs.tp_ur,
                 a150221ngs.tp_addr,
                 a150221ngs.tp_kod,
                 a150221ngstps.contact_lpr,
                 DECODE (a150221ngstps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a150221ngs.fio_eta, a150221ngs.tp_ur)