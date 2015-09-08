/* Formatted on 24.01.2014 16:38:04 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1403vc.tab_num,
                 st.fio fio_ts,
                 a1403vc.fio_eta,
                 a1403vc.tp_ur,
                 a1403vc.tp_addr,
                 a1403vc.tp_kod,
                 DECODE (a1403vctps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1403vctps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1403vc.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1403vc_tp_select a1403vctps, a1403vc, user_list st
           WHERE     a1403vc.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1403vc.tp_kod = a1403vctps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1403vc.tab_num,
                 st.fio,
                 a1403vc.fio_eta,
                 a1403vc.tp_ur,
                 a1403vc.tp_addr,
                 a1403vc.tp_kod,
                 a1403vctps.contact_lpr,
                 DECODE (a1403vctps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1403vc.fio_eta, a1403vc.tp_ur)