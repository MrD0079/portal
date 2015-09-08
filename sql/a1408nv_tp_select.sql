/* Formatted on 24.02.2014 9:55:34 (QP5 v5.227.12220.39724) */
  SELECT a1408nv.tab_num,
         st.fio fio_ts,
         a1408nv.fio_eta,
         a1408nv.tp_ur,
         a1408nv.tp_addr,
         a1408nv.tp_kod,
         DECODE (a1408nvtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1408nvtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1408nv.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1408nv_tp_select a1408nvtps, a1408nv, user_list st
   WHERE     a1408nv.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1408nv.tp_kod = a1408nvtps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a1408nv.tab_num,
         st.fio,
         a1408nv.fio_eta,
         a1408nv.tp_ur,
         a1408nv.tp_addr,
         a1408nv.tp_kod,
         a1408nvtps.contact_lpr,
         DECODE (a1408nvtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1408nv.fio_eta, a1408nv.tp_ur