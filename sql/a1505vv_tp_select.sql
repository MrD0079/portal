/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1505vv.tab_num,
         st.fio fio_ts,
         a1505vv.fio_eta,
         a1505vv.tp_ur,
         a1505vv.tp_addr,
         a1505vv.tp_kod,
         DECODE (a1505vvtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1505vvtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1505vv.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1505vv_tp_select a1505vvtps, a1505vv, user_list st
   WHERE     a1505vv.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1505vv.tp_kod = a1505vvtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1505vv.tab_num,
         st.fio,
         a1505vv.fio_eta,
         a1505vv.tp_ur,
         a1505vv.tp_addr,
         a1505vv.tp_kod,
         a1505vvtps.contact_lpr,
         DECODE (a1505vvtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1505vv.fio_eta, a1505vv.tp_ur