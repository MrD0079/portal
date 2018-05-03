/* Formatted on 29/01/2015 12:13:36 (QP5 v5.227.12220.39724) */
  SELECT a1805db.tab_num,
         st.fio fio_ts,
         a1805db.fio_eta,
         a1805db.tp_ur,
         a1805db.tp_addr,
         a1805db.tp_kod,
         DECODE (a1805dbtps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1805dbtps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1805db.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1805db_tp_select a1805dbtps, a1805db, user_list st
   WHERE     a1805db.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1805db.tp_kod = a1805dbtps.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY a1805db.tab_num,
         st.fio,
         a1805db.fio_eta,
         a1805db.tp_ur,
         a1805db.tp_addr,
         a1805db.tp_kod,
         a1805dbtps.contact_lpr,
         DECODE (a1805dbtps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1805db.fio_eta, a1805db.tp_ur