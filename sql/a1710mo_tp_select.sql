/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1710mo.tab_num,
         st.fio fio_ts,
         a1710mo.fio_eta,
         a1710mo.tp_ur,
         a1710mo.tp_addr,
         a1710mo.tp_kod,
         DECODE (a1710motps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1710motps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1710mo.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1710mo_tp_select a1710motps, a1710mo, user_list st
   WHERE     a1710mo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1710mo.tp_kod = a1710motps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1710mo.tab_num,
         st.fio,
         a1710mo.fio_eta,
         a1710mo.tp_ur,
         a1710mo.tp_addr,
         a1710mo.tp_kod,
         a1710motps.contact_lpr,
         DECODE (a1710motps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1710mo.fio_eta, a1710mo.tp_ur