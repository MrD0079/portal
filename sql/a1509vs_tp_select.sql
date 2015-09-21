/* Formatted on 21/09/2015 13:24:03 (QP5 v5.227.12220.39724) */
  SELECT a.tab_num,
         st.fio fio_ts,
         a.fio_eta,
         a.tp_ur,
         a.tp_addr,
         a.tp_kod,
         DECODE (tp.tp_kod, NULL, NULL, 1) selected,
         NVL (tp.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1509vs_tp_select tp,
         a1509vs a,
         user_list st,
         a1509vs_flag f
   WHERE     a.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a.tp_kod = tp.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND a.tp_kod = f.tp_kod(+) and f.tp_kod is null
         AND TO_NUMBER (TO_CHAR (a.data, 'mm')) = :month
         AND tp.m(+) = :month
GROUP BY a.tab_num,
         st.fio,
         a.fio_eta,
         a.tp_ur,
         a.tp_addr,
         a.tp_kod,
         tp.contact_lpr,
         DECODE (tp.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a.fio_eta, a.tp_ur