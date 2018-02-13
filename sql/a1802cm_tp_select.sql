/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1802cm.tab_num,
         st.fio fio_ts,
         a1802cm.fio_eta,
         a1802cm.tp_ur,
         a1802cm.tp_addr,
         a1802cm.tp_kod,
         DECODE (a1802cmtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1802cmtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1802cm.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1802cm_select a1802cmtps, a1802cm, user_list st
   WHERE     a1802cm.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1802cm.tp_kod = a1802cmtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1802cm.tab_num,
         st.fio,
         a1802cm.fio_eta,
         a1802cm.tp_ur,
         a1802cm.tp_addr,
         a1802cm.tp_kod,
         a1802cmtps.contact_lpr,
         DECODE (a1802cmtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1802cm.fio_eta, a1802cm.tp_ur