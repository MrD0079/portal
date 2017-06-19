/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1503f.tab_num,
         st.fio fio_ts,
         a1503f.fio_eta,
         a1503f.tp_ur,
         a1503f.tp_addr,
         a1503f.tp_kod,
         DECODE (a1503ftps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1503ftps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1503f.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1503f_tp_select a1503ftps, a1503f, user_list st
   WHERE     a1503f.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1503f.tp_kod = a1503ftps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1503f.tab_num,
         st.fio,
         a1503f.fio_eta,
         a1503f.tp_ur,
         a1503f.tp_addr,
         a1503f.tp_kod,
         a1503ftps.contact_lpr,
         DECODE (a1503ftps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1503f.fio_eta, a1503f.tp_ur