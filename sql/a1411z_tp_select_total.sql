/* Formatted on 26/11/2014 17:27:29 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1411z.tab_num,
                 st.fio fio_ts,
                 a1411z.fio_eta,
                 a1411z.tp_ur,
                 a1411z.tp_addr,
                 a1411z.tp_kod_key,
                 DECODE (a1411ztps.tp_kod_key, NULL, NULL, 1) selected,
                 NVL (a1411ztps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1411z.tp_kod_key AND ROWNUM = 1))
                    contact_lpr
            FROM a1411z_tp_select a1411ztps, a1411z, user_list st
           WHERE     a1411z.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1411z.tp_kod_key = a1411ztps.tp_kod_key(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1411z.tab_num,
                 st.fio,
                 a1411z.fio_eta,
                 a1411z.tp_ur,
                 a1411z.tp_addr,
                 a1411z.tp_kod_key,
                 a1411ztps.contact_lpr,
                 DECODE (a1411ztps.tp_kod_key, NULL, NULL, 1)
        ORDER BY st.fio, a1411z.fio_eta, a1411z.tp_ur)