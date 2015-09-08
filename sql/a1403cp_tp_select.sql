/* Formatted on 24.02.2014 9:55:34 (QP5 v5.227.12220.39724) */
  SELECT a1403cp.tab_num,
         st.fio fio_ts,
         a1403cp.fio_eta,
         a1403cp.tp_ur,
         a1403cp.tp_addr,
         a1403cp.tp_kod,
         DECODE (a1403cptps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1403cptps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1403cp.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1403cp_tp_select a1403cptps, a1403cp, user_list st
   WHERE     a1403cp.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1403cp.tp_kod = a1403cptps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1403cp.tab_num,
         st.fio,
         a1403cp.fio_eta,
         a1403cp.tp_ur,
         a1403cp.tp_addr,
         a1403cp.tp_kod,
         a1403cptps.contact_lpr,
         DECODE (a1403cptps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1403cp.fio_eta, a1403cp.tp_ur