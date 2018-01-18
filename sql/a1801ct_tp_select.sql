/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1801ct.tab_num,
         st.fio fio_ts,
         a1801ct.fio_eta,
         a1801ct.tp_ur,
         a1801ct.tp_addr,
         a1801ct.tp_kod,
         DECODE (a1801cttps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1801cttps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1801ct.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1801ct_tp_select a1801cttps, a1801ct, user_list st
   WHERE     a1801ct.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1801ct.tp_kod = a1801cttps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1801ct.tab_num,
         st.fio,
         a1801ct.fio_eta,
         a1801ct.tp_ur,
         a1801ct.tp_addr,
         a1801ct.tp_kod,
         a1801cttps.contact_lpr,
         DECODE (a1801cttps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1801ct.fio_eta, a1801ct.tp_ur