/* Formatted on 18/04/2016 15:39:18 (QP5 v5.252.13127.32867) */
  SELECT m.tab_num,
         st.fio fio_ts,
         m.eta fio_eta,
         m.tp_ur,
         m.tp_addr,
         a16p5tp.tp_kod,
         DECODE (a16p5tptps.tp_kod, NULL, NULL, 1) selected,
         NVL (a16p5tptps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a16p5tp.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a16p5tp_select a16p5tptps,
         a16p5tp,
         user_list st,
         a14mega m
   WHERE     m.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a16p5tp.tp_kod = a16p5tptps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND a16p5tp.tp_kod = m.tp_kod
         AND m.dt = to_date('01/04/2016','dd/mm/yyyy')
GROUP BY m.tab_num,
         st.fio,
         m.eta,
         m.tp_ur,
         m.tp_addr,
         a16p5tp.tp_kod,
         a16p5tptps.contact_lpr,
         DECODE (a16p5tptps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, m.eta, m.tp_ur