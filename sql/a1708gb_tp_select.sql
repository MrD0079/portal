/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT A1708GB.tab_num,
         st.fio fio_ts,
         A1708GB.fio_eta,
         A1708GB.tp_ur,
         A1708GB.tp_addr,
         A1708GB.tp_kod,
         DECODE (A1708GBtps.tp_kod, NULL, NULL, 1) selected,
         NVL (A1708GBtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = A1708GB.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM A1708GB_select A1708GBtps, A1708GB, user_list st
   WHERE     A1708GB.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND A1708GB.tp_kod = A1708GBtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY A1708GB.tab_num,
         st.fio,
         A1708GB.fio_eta,
         A1708GB.tp_ur,
         A1708GB.tp_addr,
         A1708GB.tp_kod,
         A1708GBtps.contact_lpr,
         DECODE (A1708GBtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, A1708GB.fio_eta, A1708GB.tp_ur