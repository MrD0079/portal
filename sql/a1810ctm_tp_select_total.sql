/* Formatted on 18/04/2016 15:39:32 (QP5 v5.252.13127.32867) */
SELECT SUM (selected)
  FROM (/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1810ctm.tab_num,
         st.fio fio_ts,
         a1810ctm.fio_eta,
         a1810ctm.tp_ur,
         a1810ctm.tp_addr,
         a1810ctm.tp_kod,
         DECODE (a1810ctmtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1810ctmtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1810ctm.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1810ctm_select a1810ctmtps, a1810ctm, user_list st
   WHERE     a1810ctm.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1810ctm.tp_kod = a1810ctmtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1810ctm.tab_num,
         st.fio,
         a1810ctm.fio_eta,
         a1810ctm.tp_ur,
         a1810ctm.tp_addr,
         a1810ctm.tp_kod,
         a1810ctmtps.contact_lpr,
         DECODE (a1810ctmtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1810ctm.fio_eta, a1810ctm.tp_ur)