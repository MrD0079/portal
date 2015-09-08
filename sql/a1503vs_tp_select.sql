/* Formatted on 03/04/2015 13:07:47 (QP5 v5.227.12220.39724) */
  SELECT ny.tab_num,
         st.fio fio_ts,
         ny.fio_eta,
         ny.tp_ur,
         ny.tp_addr,
         ny.tp_kod,
         DECODE (a1503vstps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1503vstps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = ny.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1503vs_tp_select a1503vstps, a1503vs ny, user_list st
   WHERE     ny.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ny.tp_kod = a1503vstps.tp_kod(+)
         AND st.dpt_id = :dpt_id
ORDER BY st.fio, ny.fio_eta, ny.tp_ur