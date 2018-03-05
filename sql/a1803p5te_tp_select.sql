/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1803p5te.tab_num,
         st.fio fio_ts,
         a1803p5te.fio_eta,
         a1803p5te.tp_ur,
         a1803p5te.tp_addr,
         a1803p5te.tp_kod,
         DECODE (a1803p5tetps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1803p5tetps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1803p5te.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1803p5te_select a1803p5tetps, a1803p5te, user_list st
   WHERE     a1803p5te.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1803p5te.tp_kod = a1803p5tetps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1803p5te.tab_num,
         st.fio,
         a1803p5te.fio_eta,
         a1803p5te.tp_ur,
         a1803p5te.tp_addr,
         a1803p5te.tp_kod,
         a1803p5tetps.contact_lpr,
         DECODE (a1803p5tetps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1803p5te.fio_eta, a1803p5te.tp_ur