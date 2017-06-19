/* Formatted on 25/07/2014 15:39:21 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (/* Formatted on 29/01/2015 17:41:02 (QP5 v5.227.12220.39724) */
  SELECT z.tab_num,
         st.fio fio_ts,
         z.fio_eta,
         z.tp_ur,z.tp_addr,
         z.tp_kod,
         DECODE (z1.tp_kod, NULL, NULL, 1) selected,
         NVL (z1.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = z.tp_kod AND ROWNUM = 1))
            contact_lpr
    FROM a1501plpr_tp_select z1, a1501plpr z, user_list st
   WHERE     z.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND z.tp_kod = z1.tp_kod(+)
         AND st.dpt_id = :dpt_id and st.is_spd=1
GROUP BY z.tab_num,
         st.fio,
         z.fio_eta,
         z.tp_ur,
         z.tp_addr,
         z.tp_kod,
         z1.contact_lpr,
         DECODE (z1.tp_kod, NULL, NULL, 1)
ORDER BY st.fio, z.fio_eta, z.tp_ur)
