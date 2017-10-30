/* Formatted on 18/04/2016 15:39:32 (QP5 v5.252.13127.32867) */
SELECT SUM (selected)
  FROM (/* Formatted on 19.08.2017 11:43:39 (QP5 v5.252.13127.32867) */
  SELECT a1710oo.tab_num,
         st.fio fio_ts,
         a1710oo.fio_eta,
         a1710oo.tp_ur,
         a1710oo.tp_addr,
         a1710oo.tp_kod,
         DECODE (a1710ootps.tp_kod, NULL, NULL, 1) selected,
         NVL (a1710ootps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a1710oo.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1710oo_select a1710ootps, a1710oo, user_list st
   WHERE     a1710oo.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND a1710oo.tp_kod = a1710ootps.tp_kod(+)
         AND st.dpt_id = :dpt_id
         AND st.is_spd = 1
GROUP BY a1710oo.tab_num,
         st.fio,
         a1710oo.fio_eta,
         a1710oo.tp_ur,
         a1710oo.tp_addr,
         a1710oo.tp_kod,
         a1710ootps.contact_lpr,
         DECODE (a1710ootps.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, a1710oo.fio_eta, a1710oo.tp_ur)